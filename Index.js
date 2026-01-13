<script>
    // DOM Elements
    const voiceInput = document.getElementById('voiceInput');
    const voiceDropArea = document.getElementById('voiceDropArea');
    const imageInput = document.getElementById('imageInput');
    const imageDropArea = document.getElementById('imageDropArea');
    const audioPreview = document.getElementById('audioPreview');
    const imagePreview = document.getElementById('imagePreview');
    const generateBtn = document.getElementById('generateBtn');
    const processingSection = document.getElementById('processingSection');
    const outputSection = document.getElementById('outputSection');
    const playBtn = document.getElementById('playBtn');
    const pauseBtn = document.getElementById('pauseBtn');
    const timeDisplay = document.getElementById('timeDisplay');
    const timelineProgress = document.querySelector('.timeline-progress');
    const timelineMarker = document.querySelector('.timeline-marker');
    const timelineImages = document.getElementById('timelineImages');
    const segmentsList = document.getElementById('segmentsList');
    const downloadBtn = document.getElementById('downloadBtn');
    const styleOptions = document.querySelectorAll('.style-option');
    const languageSelect = document.getElementById('language');
    
    // State variables
    let uploadedAudio = null;
    let uploadedImages = [];
    let isProcessing = false;
    let isPlaying = false;
    let currentTime = 0;
    let totalTime = 0;
    let audioElement = null;
    let videoStyle = 'cinematic';
    let selectedLanguage = 'auto';
    let segments = [];
    let timelineMarkers = [];
    
    // Sample data for demonstration
    const sampleSegments = [
        {
            text: "The sun rose over the majestic mountains, casting a golden glow across the valley.",
            startTime: 0,
            endTime: 5,
            subject: "Sunrise over mountains",
            emotion: "Awe, wonder",
            action: "Rising, casting light"
        },
        {
            text: "A lone wolf howled in the distance, calling to its pack as the forest awoke.",
            startTime: 5,
            endTime: 10,
            subject: "Wolf in forest",
            emotion: "Loneliness, alertness",
            action: "Howling, calling"
        },
        {
            text: "The river flowed gently, carrying leaves and stories from distant lands.",
            startTime: 10,
            endTime: 15,
            subject: "River flow",
            emotion: "Calm, continuity",
            action: "Flowing, carrying"
        },
        {
            text: "Children laughed and played in the meadow, their joy echoing through the hills.",
            startTime: 15,
            endTime: 20,
            subject: "Children playing",
            emotion: "Joy, happiness",
            action: "Laughing, playing"
        },
        {
            text: "As night fell, the stars emerged one by one, painting the sky with silver light.",
            startTime: 20,
            endTime: 25,
            subject: "Night sky with stars",
            emotion: "Peace, wonder",
            action: "Emerging, painting"
        }
    ];
    
    // Image URLs for demonstration (from Unsplash)
    const sampleImages = [
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
        'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
        'https://images.unsplash.com/photo-1439066615861-d1af74d74000?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
        'https://images.unsplash.com/photo-1465101162946-4377e57745c3?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80'
    ];
    
    // Initialize the application
    function init() {
        // Set up event listeners
        setupEventListeners();
        // Set default video style
        setVideoStyle('cinematic');
    }
    
    // Set up all event listeners
    function setupEventListeners() {
        // Voice file upload
        voiceDropArea.addEventListener('click', () => voiceInput.click());
        voiceDropArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            voiceDropArea.style.borderColor = '#3498db';
            voiceDropArea.style.backgroundColor = 'rgba(52, 152, 219, 0.1)';
        });
        voiceDropArea.addEventListener('dragleave', () => {
            voiceDropArea.style.borderColor = '#4a6572';
            voiceDropArea.style.backgroundColor = 'rgba(40, 55, 75, 0.5)';
        });
        voiceDropArea.addEventListener('drop', (e) => {
            e.preventDefault();
            voiceDropArea.style.borderColor = '#4a6572';
            voiceDropArea.style.backgroundColor = 'rgba(40, 55, 75, 0.5)';
            
            if (e.dataTransfer.files.length) {
                voiceInput.files = e.dataTransfer.files;
                handleVoiceUpload(e.dataTransfer.files[0]);
            }
        });
        voiceInput.addEventListener('change', (e) => {
            if (e.target.files.length) {
                handleVoiceUpload(e.target.files[0]);
            }
        });
        
        // Image file upload
        imageDropArea.addEventListener('click', () => imageInput.click());
        imageDropArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            imageDropArea.style.borderColor = '#3498db';
            imageDropArea.style.backgroundColor = 'rgba(52, 152, 219, 0.1)';
        });
        imageDropArea.addEventListener('dragleave', () => {
            imageDropArea.style.borderColor = '#4a6572';
            imageDropArea.style.backgroundColor = 'rgba(40, 55, 75, 0.5)';
        });
        imageDropArea.addEventListener('drop', (e) => {
            e.preventDefault();
            imageDropArea.style.borderColor = '#4a6572';
            imageDropArea.style.backgroundColor = 'rgba(40, 55, 75, 0.5)';
            
            if (e.dataTransfer.files.length) {
                const files = Array.from(e.dataTransfer.files);
                handleImageUpload(files);
            }
        });
        imageInput.addEventListener('change', (e) => {
            if (e.target.files.length) {
                const files = Array.from(e.target.files);
                handleImageUpload(files);
            }
        });
        
        // Generate button
        generateBtn.addEventListener('click', startProcessing);
        
        // Video style selection
        styleOptions.forEach(option => {
            option.addEventListener('click', () => {
                const style = option.getAttribute('data-style');
                setVideoStyle(style);
            });
        });
        
        // Language selection
        languageSelect.addEventListener('change', (e) => {
            selectedLanguage = e.target.value;
        });
        
        // Video controls
        playBtn.addEventListener('click', playVideo);
        pauseBtn.addEventListener('click', pauseVideo);
        
        // Timeline click
        document.querySelector('.timeline-bar').addEventListener('click', (e) => {
            if (!audioElement) return;
            
            const rect = e.target.getBoundingClientRect();
            const clickX = e.clientX - rect.left;
            const percentage = clickX / rect.width;
            const time = percentage * totalTime;
            
            audioElement.currentTime = time;
            updateTimeline();
        });
        
        // Download button
        downloadBtn.addEventListener('click', downloadVideo);
    }
    
    // Handle voice file upload
    function handleVoiceUpload(file) {
        // Check file size (max 500MB)
        if (file.size > 500 * 1024 * 1024) {
            alert('File size exceeds 500MB limit. Please upload a smaller file.');
            return;
        }
        
        // Check file type
        if (!file.type.startsWith('audio/')) {
            alert('Please upload an audio file (MP3, WAV, M4A, etc.)');
            return;
        }
        
        uploadedAudio = file;
        
        // Create audio preview
        const audioURL = URL.createObjectURL(file);
        audioPreview.innerHTML = `
            <div class="audio-player">
                <p><strong>Uploaded:</strong> ${file.name} (${formatFileSize(file.size)})</p>
                <audio controls style="width: 100%; margin-top: 10px;">
                    <source src="${audioURL}" type="${file.type}">
                </audio>
            </div>
        `;
        
        // Create audio element for playback control
        audioElement = new Audio(audioURL);
        audioElement.addEventListener('loadedmetadata', () => {
            totalTime = audioElement.duration;
            updateTimeDisplay();
        });
        audioElement.addEventListener('timeupdate', updateTimeline);
        audioElement.addEventListener('ended', () => {
            isPlaying = false;
            playBtn.style.display = 'flex';
            pauseBtn.style.display = 'none';
        });
        
        // Update UI
        generateBtn.disabled = false;
        voiceDropArea.innerHTML = `
            <i class="fas fa-check-circle" style="color: #2ecc71;"></i>
            <p>Voice file uploaded successfully</p>
            <p class="file-size">${file.name}</p>
        `;
    }
    
    // Handle image file upload
    function handleImageUpload(files) {
        // Filter to only image files
        const imageFiles = files.filter(file => file.type.startsWith('image/'));
        
        if (imageFiles.length === 0) {
            alert('Please upload image files (JPG, PNG, SVG, etc.)');
            return;
        }
        
        // Add to uploaded images array
        imageFiles.forEach(file => {
            uploadedImages.push(file);
            
            // Create image preview
            const reader = new FileReader();
            reader.onload = (e) => {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'preview-image';
                img.title = file.name;
                imagePreview.appendChild(img);
            };
            reader.readAsDataURL(file);
        });
        
        // Update UI
        imageDropArea.innerHTML = `
            <i class="fas fa-check-circle" style="color: #2ecc71;"></i>
            <p>${imageFiles.length} image(s) uploaded</p>
            <p class="file-size">You can upload more images</p>
        `;
    }
    
    // Set video style
    function setVideoStyle(style) {
        videoStyle = style;
        
        // Update UI
        styleOptions.forEach(option => {
            if (option.getAttribute('data-style') === style) {
                option.classList.add('active');
            } else {
                option.classList.remove('active');
            }
        });
    }
    
    // Start the AI processing simulation
    function startProcessing() {
        if (!uploadedAudio) {
            alert('Please upload a voice narration file first.');
            return;
        }
        
        if (isProcessing) return;
        
        isProcessing = true;
        generateBtn.disabled = true;
        generateBtn.innerHTML = `<i class="fas fa-spinner fa-spin"></i> Processing...`;
        
        // Show processing section
        processingSection.style.display = 'block';
        
        // Reset steps
        document.querySelectorAll('.step').forEach(step => {
            step.classList.remove('active', 'completed');
            const progressFill = step.querySelector('.progress-fill');
            progressFill.style.width = '0%';
        });
        
        // Start step-by-step simulation
        simulateProcessing();
    }
    
    // Simulate AI processing steps
    function simulateProcessing() {
        const steps = document.querySelectorAll('.step');
        
        // Step 1: Analyzing Narration
        activateStep(0, 2000, () => {
            // Step 2: Identifying Subjects & Emotions
            activateStep(1, 2500, () => {
                // Step 3: Matching Images
                activateStep(2, 3000, () => {
                    // Step 4: Creating Timeline
                    activateStep(3, 2500, () => {
                        // Step 5: Finalizing Video
                        activateStep(4, 2000, () => {
                            // Processing complete
                            setTimeout(() => {
                                processingSection.style.display = 'none';
                                outputSection.style.display = 'block';
                                generateVideoOutput();
                                isProcessing = false;
                                generateBtn.disabled = false;
                                generateBtn.innerHTML = `<i class="fas fa-magic"></i> Generate AI Video`;
                            }, 1000);
                        });
                    });
                });
            });
        });
    }
    
    // Activate a processing step with animation
    function activateStep(stepIndex, duration, callback) {
        const step = document.getElementById(`step${stepIndex + 1}`);
        const progressFill = step.querySelector('.progress-fill');
        
        step.classList.add('active');
        
        // Animate progress bar
        let progress = 0;
        const interval = setInterval(() => {
            progress += 2;
            progressFill.style.width = `${progress}%`;
            
            if (progress >= 100) {
                clearInterval(interval);
                step.classList.remove('active');
                step.classList.add('completed');
                
                // Call next step
                setTimeout(callback, 500);
            }
        }, duration / 50);
    }
    
    // Generate the video output UI
    function generateVideoOutput() {
        // Use sample segments for demonstration
        segments = sampleSegments;
        
        // Calculate total time
        totalTime = segments[segments.length - 1].endTime;
        
        // Update time display
        updateTimeDisplay();
        
        // Create timeline markers
        createTimelineMarkers();
        
        // Create segments list
        createSegmentsList();
        
        // Update video placeholder
        const videoPlaceholder = document.querySelector('.video-placeholder');
        videoPlaceholder.innerHTML = `
            <div style="position: relative; width: 100%; height: 100%; overflow: hidden; border-radius: 5px;">
                <div id="dynamicImage" style="width: 100%; height: 100%; background-size: cover; background-position: center; background-image: url('${sampleImages[0]}');"></div>
                <div style="position: absolute; bottom: 20px; left: 20px; background: rgba(0,0,0,0.7); padding: 15px; border-radius: 8px; max-width: 80%;">
                    <p style="color: white; font-size: 1.2rem; margin-bottom: 5px;">${segments[0].text}</p>
                    <div style="display: flex; gap: 15px; font-size: 0.9rem;">
                        <span style="color: #3498db;"><i class="fas fa-bullseye"></i> ${segments[0].subject}</span>
                        <span style="color: #e74c3c;"><i class="fas fa-smile"></i> ${segments[0].emotion}</span>
                    </div>
                </div>
            </div>
        `;
        
        // Set up image switching based on audio time
        if (audioElement) {
            audioElement.addEventListener('timeupdate', () => {
                const currentTime = audioElement.currentTime;
                
                // Find current segment
                const currentSegmentIndex = segments.findIndex(segment => 
                    currentTime >= segment.startTime && currentTime < segment.endTime
                );
                
                if (currentSegmentIndex >= 0) {
                    // Update active segment in list
                    document.querySelectorAll('.segment-item').forEach((item, index) => {
                        if (index === currentSegmentIndex) {
                            item.classList.add('active');
                        } else {
                            item.classList.remove('active');
                        }
                    });
                    
                    // Update active image on timeline
                    document.querySelectorAll('.timeline-image').forEach((img, index) => {
                        if (index === currentSegmentIndex) {
                            img.classList.add('active');
                        } else {
                            img.classList.remove('active');
                        }
                    });
                    
                    // Update the displayed image
                    const dynamicImage = document.getElementById('dynamicImage');
                    if (dynamicImage) {
                        dynamicImage.style.backgroundImage = `url('${sampleImages[currentSegmentIndex]}')`;
                        
                        // Update the text overlay if it exists
                        const textOverlay = dynamicImage.parentElement.querySelector('div > p');
                        if (textOverlay) {
                            textOverlay.textContent = segments[currentSegmentIndex].text;
                            
                            // Update details
                            const details = dynamicImage.parentElement.querySelectorAll('span');
                            if (details.length >= 2) {
                                details[0].innerHTML = `<i class="fas fa-bullseye"></i> ${segments[currentSegmentIndex].subject}`;
                                details[1].innerHTML = `<i class="fas fa-smile"></i> ${segments[currentSegmentIndex].emotion}`;
                            }
                        }
                    }
                }
            });
        }
    }
    
    // Create timeline markers for each segment
    function createTimelineMarkers() {
        timelineImages.innerHTML = '';
        
        segments.forEach((segment, index) => {
            const positionPercentage = (segment.startTime / totalTime) * 100;
            
            const img = document.createElement('img');
            img.src = sampleImages[index % sampleImages.length];
            img.className = 'timeline-image';
            img.style.left = `${positionPercentage}%`;
            img.title = segment.subject;
            
            timelineImages.appendChild(img);
        });
        
        // Set first image as active
        if (timelineImages.firstChild) {
            timelineImages.firstChild.classList.add('active');
        }
    }
    
    // Create segments list
    function createSegmentsList() {
        segmentsList.innerHTML = '';
        
        segments.forEach((segment, index) => {
            const segmentItem = document.createElement('div');
            segmentItem.className = 'segment-item' + (index === 0 ? ' active' : '');
            segmentItem.innerHTML = `
                <div class="segment-text">${segment.text}</div>
                <div class="segment-details">
                    <div class="segment-subject">
                        <i class="fas fa-bullseye"></i>
                        <span>${segment.subject}</span>
                    </div>
                    <div class="segment-emotion">
                        <i class="fas fa-smile"></i>
                        <span>${segment.emotion}</span>
                    </div>
                    <div class="segment-time">
                        <i class="fas fa-clock"></i>
                        <span>${formatTime(segment.startTime)} - ${formatTime(segment.endTime)}</spa