<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Video Editor | Voice-to-Visual Sync</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        /* CSS will be added here */
    </style>
</head>
<body>
    <div class="container">
        <header class="app-header">
            <div class="logo">
                <i class="fas fa-film"></i>
                <h1>AI Video Editor</h1>
            </div>
            <p class="tagline">Transform voice narration into cinematic videos with AI-powered image matching</p>
        </header>

        <main class="main-content">
            <div class="upload-section">
                <div class="upload-box voice-upload">
                    <h2><i class="fas fa-microphone"></i> Upload Voice Narration</h2>
                    <p class="upload-info">Supports MP3, WAV, M4A (Max 2 hours)</p>
                    <div class="drop-area" id="voiceDropArea">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <p>Drag & drop your voice file here</p>
                        <p class="file-size">or click to browse (max 500MB)</p>
                        <input type="file" id="voiceInput" accept="audio/*" hidden>
                    </div>
                    <div class="audio-preview" id="audioPreview">
                        <!-- Audio preview will appear here -->
                    </div>
                </div>

                <div class="upload-box image-upload">
                    <h2><i class="fas fa-images"></i> Upload Images (Optional)</h2>
                    <p class="upload-info">AI will use these or generate relevant images (Unlimited uploads)</p>
                    <div class="drop-area" id="imageDropArea">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <p>Drag & drop your images here</p>
                        <p class="file-size">or click to browse (JPG, PNG, SVG)</p>
                        <input type="file" id="imageInput" accept="image/*" multiple hidden>
                    </div>
                    <div class="image-preview" id="imagePreview">
                        <!-- Image previews will appear here -->
                    </div>
                </div>
            </div>

            <div class="controls-section">
                <div class="language-selector">
                    <label for="language"><i class="fas fa-language"></i> Narration Language:</label>
                    <select id="language">
                        <option value="auto">Auto-detect (Hindi/Hinglish/English)</option>
                        <option value="en">English</option>
                        <option value="hi">Hindi</option>
                        <option value="hinglish">Hinglish</option>
                    </select>
                </div>

                <div class="style-controls">
                    <h3><i class="fas fa-palette"></i> Video Style</h3>
                    <div class="style-options">
                        <div class="style-option active" data-style="cinematic">
                            <i class="fas fa-theater-masks"></i>
                            <span>Cinematic</span>
                        </div>
                        <div class="style-option" data-style="informative">
                            <i class="fas fa-chart-line"></i>
                            <span>Informative</span>
                        </div>
                        <div class="style-option" data-style="dramatic">
                            <i class="fas fa-fire"></i>
                            <span>Dramatic</span>
                        </div>
                    </div>
                </div>

                <button class="generate-btn" id="generateBtn">
                    <i class="fas fa-magic"></i> Generate AI Video
                </button>
            </div>

            <div class="processing-section" id="processingSection">
                <h2><i class="fas fa-cogs"></i> AI Processing Steps</h2>
                <div class="processing-steps">
                    <div class="step" id="step1">
                        <div class="step-icon"><i class="fas fa-volume-up"></i></div>
                        <div class="step-content">
                            <h3>1. Analyzing Narration</h3>
                            <p>Splitting into logical segments (1-2 sentences each)</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="step" id="step2">
                        <div class="step-icon"><i class="fas fa-brain"></i></div>
                        <div class="step-content">
                            <h3>2. Identifying Subjects & Emotions</h3>
                            <p>Detecting main subject, emotion, and action for each segment</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="step" id="step3">
                        <div class="step-icon"><i class="fas fa-image"></i></div>
                        <div class="step-content">
                            <h3>3. Matching Images</h3>
                            <p>Selecting highly relevant images for each narration segment</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="step" id="step4">
                        <div class="step-icon"><i class="fas fa-film"></i></div>
                        <div class="step-content">
                            <h3>4. Creating Timeline</h3>
                            <p>Placing images in correct sequence with perfect timing sync</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="step" id="step5">
                        <div class="step-icon"><i class="fas fa-play-circle"></i></div>
                        <div class="step-content">
                            <h3>5. Finalizing Video</h3>
                            <p>Applying cinematic framing, smooth transitions, and 16:9 ratio</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="output-section" id="outputSection">
                <h2><i class="fas fa-video"></i> Generated Video Preview</h2>
                <div class="video-container">
                    <div class="video-player">
                        <div class="video-placeholder">
                            <i class="fas fa-play-circle"></i>
                            <p>Your AI-generated video will appear here</p>
                        </div>
                        <div class="video-controls">
                            <div class="timeline">
                                <div class="timeline-bar">
                                    <div class="timeline-progress"></div>
                                    <div class="timeline-marker"></div>
                                </div>
                                <div class="timeline-images" id="timelineImages">
                                    <!-- Timeline image markers will appear here -->
                                </div>
                            </div>
                            <div class="control-buttons">
                                <button class="ctrl-btn" id="playBtn"><i class="fas fa-play"></i></button>
                                <button class="ctrl-btn" id="pauseBtn"><i class="fas fa-pause"></i></button>
                                <span class="time-display" id="timeDisplay">0:00 / 0:00</span>
                                <button class="download-btn" id="downloadBtn">
                                    <i class="fas fa-download"></i> Download Video
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="segments-panel">
                        <h3><i class="fas fa-list-ol"></i> Narration Segments</h3>
                        <div class="segments-list" id="segmentsList">
                            <!-- Narration segments will appear here -->
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer>
            <p>AI Video Editor • Automatically syncs voice with relevant images • Max 2-hour video length</p>
            <p class="features">
                <span><i class="fas fa-check-circle"></i> Logical segmentation</span>
                <span><i class="fas fa-check-circle"></i> Emotion detection</span>
                <span><i class="fas fa-check-circle"></i> Visual continuity</span>
                <span><i class="fas fa-check-circle"></i> 16:9 cinematic ratio</span>
            </p>
        </footer>
    </div>

    <script>
        // JavaScript will be added here
    </script>
</body>
</html>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #0f1b2f 0%, #1a2b3c 100%);
        color: #e0e0e0;
        min-height: 100vh;
        padding: 20px;
    }

    .container {
        max-width: 1400px;
        margin: 0 auto;
        background-color: rgba(25, 35, 50, 0.9);
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
    }

    .app-header {
        padding: 25px 40px;
        background: linear-gradient(90deg, #1e2b3a 0%, #2c3e50 100%);
        border-bottom: 1px solid #34495e;
    }

    .logo {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 10px;
    }

    .logo i {
        font-size: 2.5rem;
        color: #3498db;
    }

    .logo h1 {
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
        font-size: 2.2rem;
        background: linear-gradient(to right, #3498db, #2ecc71);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .tagline {
        font-size: 1.1rem;
        color: #95a5a6;
        max-width: 800px;
    }

    .main-content {
        padding: 30px 40px;
    }

    .upload-section {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 30px;
        margin-bottom: 40px;
    }

    @media (max-width: 1024px) {
        .upload-section {
            grid-template-columns: 1fr;
        }
    }

    .upload-box {
        background-color: rgba(30, 40, 60, 0.8);
        border-radius: 15px;
        padding: 25px;
        border: 2px dashed #34495e;
        transition: all 0.3s ease;
    }

    .upload-box:hover {
        border-color: #3498db;
        transform: translateY(-5px);
    }

    .upload-box h2 {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 10px;
        color: #3498db;
        font-size: 1.4rem;
    }

    .upload-box h2 i {
        font-size: 1.6rem;
    }

    .upload-info {
        color: #95a5a6;
        margin-bottom: 20px;
        font-size: 0.95rem;
    }

    .drop-area {
        border: 2px dashed #4a6572;
        border-radius: 10px;
        padding: 40px 20px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
        background-color: rgba(40, 55, 75, 0.5);
    }

    .drop-area:hover {
        border-color: #3498db;
        background-color: rgba(52, 152, 219, 0.1);
    }

    .drop-area i {
        font-size: 3rem;
        color: #4a6572;
        margin-bottom: 15px;
    }

    .drop-area p {
        margin-bottom: 5px;
    }

    .file-size {
        font-size: 0.9rem;
        color: #7f8c8d;
    }

    .audio-preview, .image-preview {
        margin-top: 20px;
        min-height: 80px;
    }

    .image-preview {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }

    .preview-image {
        width: 100px;
        height: 70px;
        object-fit: cover;
        border-radius: 5px;
        border: 1px solid #34495e;
    }

    .controls-section {
        background-color: rgba(30, 40, 60, 0.8);
        border-radius: 15px;
        padding: 25px;
        margin-bottom: 40px;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
        gap: 30px;
    }

    .language-selector {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .language-selector label {
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .language-selector select {
        background-color: #2c3e50;
        color: #ecf0f1;
        border: 1px solid #4a6572;
        border-radius: 8px;
        padding: 10px 15px;
        font-size: 1rem;
        min-width: 250px;
        cursor: pointer;
    }

    .style-controls h3 {
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #3498db;
    }

    .style-options {
        display: flex;
        gap: 15px;
    }

    .style-option {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        padding: 15px;
        border-radius: 10px;
        background-color: #2c3e50;
        cursor: pointer;
        transition: all 0.3s;
        min-width: 110px;
        border: 2px solid transparent;
    }

    .style-option:hover {
        background-color: #34495e;
    }

    .style-option.active {
        border-color: #3498db;
        background-color: rgba(52, 152, 219, 0.1);
    }

    .style-option i {
        font-size: 1.8rem;
    }

    .generate-btn {
        background: linear-gradient(to right, #3498db, #2ecc71);
        color: white;
        border: none;
        border-radius: 10px;
        padding: 18px 35px;
        font-size: 1.2rem;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 12px;
        transition: all 0.3s;
        box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
    }

    .generate-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(52, 152, 219, 0.4);
    }

    .processing-section {
        background-color: rgba(30, 40, 60, 0.8);
        border-radius: 15px;
        padding: 25px;
        margin-bottom: 40px;
        display: none;
    }

    .processing-section h2 {
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #3498db;
    }

    .processing-steps {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .step {
        display: flex;
        gap: 20px;
        padding: 20px;
        background-color: rgba(40, 55, 75, 0.6);
        border-radius: 10px;
        border-left: 4px solid #2c3e50;
        transition: all 0.3s;
    }

    .step.active {
        border-left-color: #3498db;
        background-color: rgba(52, 152, 219, 0.1);
    }

    .step.completed {
        border-left-color: #2ecc71;
    }

    .step-icon {
        font-size: 2rem;
        color: #4a6572;
        width: 60px;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #2c3e50;
        border-radius: 50%;
    }

    .step.active .step-icon {
        color: #3498db;
        background-color: rgba(52, 152, 219, 0.2);
    }

    .step.completed .step-icon {
        color: #2ecc71;
        background-color: rgba(46, 204, 113, 0.2);
    }

    .step-content {
        flex: 1;
    }

    .step-content h3 {
        margin-bottom: 8px;
        color: #ecf0f1;
    }

    .step-content p {
        color: #bdc3c7;
        margin-bottom: 15px;
    }

    .progress-bar {
        height: 8px;
        background-color: #2c3e50;
        border-radius: 4px;
        overflow: hidden;
    }

    .progress-fill {
        height: 100%;
        background: linear-gradient(to right, #3498db, #2ecc71);
        width: 0%;
        border-radius: 4px;
        transition: width 0.5s ease;
    }

    .output-section {
        background-color: rgba(30, 40, 60, 0.8);
        border-radius: 15px;
        padding: 25px;
        display: none;
    }

    .output-section h2 {
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #3498db;
    }

    .video-container {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 30px;
    }

    @media (max-width: 1024px) {
        .video-container {
            grid-template-columns: 1fr;
        }
    }

    .video-player {
        background-color: #0d1520;
        border-radius: 10px;
        overflow: hidden;
    }

    .video-placeholder {
        height: 400px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #1a2530 0%, #2c3e50 100%);
    }

    .video-placeholder i {
        font-size: 6rem;
        color: #3498db;
        margin-bottom: 20px;
    }

    .video-placeholder p {
        font-size: 1.2rem;
        color: #95a5a6;
    }

    .video-controls {
        padding: 20px;
        background-color: #1a2530;
    }

    .timeline {
        margin-bottom: 20px;
    }

    .timeline-bar {
        height: 6px;
        background-color: #2c3e50;
        border-radius: 3px;
        position: relative;
        margin-bottom: 25px;
        cursor: pointer;
    }

    .timeline-progress {
        height: 100%;
        background: linear-gradient(to right, #3498db, #2ecc71);
        width: 0%;
        border-radius: 3px;
    }

    .timeline-marker {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        width: 16px;
        height: 16px;
        background-color: #ecf0f1;
        border-radius: 50%;
        left: 0%;
    }

    .timeline-images {
        display: flex;
        justify-content: space-between;
        position: relative;
        height: 40px;
    }

    .timeline-image {
        width: 50px;
        height: 35px;
        object-fit: cover;
        border-radius: 4px;
        border: 2px solid transparent;
        position: absolute;
        transform: translateX(-50%);
    }

    .timeline-image.active {
        border-color: #3498db;
        box-shadow: 0 0 10px rgba(52, 152, 219, 0.7);
    }

    .control-buttons {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .ctrl-btn {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: #2c3e50;
        border: none;
        color: #ecf0f1;
        font-size: 1.5rem;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
    }

    .ctrl-btn:hover {
        background-color: #3498db;
        transform: scale(1.05);
    }

    .time-display {
        margin-left: auto;
        font-family: 'Courier New', monospace;
        font-size: 1.1rem;
    }

    .download-btn {
        background: linear-gradient(to right, #e74c3c, #f39c12);
        color: white;
        border: none;
        border-radius: 8px;
        padding: 12px 25px;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 10px;
        transition: all 0.3s;
    }

    .download-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
    }

    .segments-panel {
        background-color: #1a2530;
        border-radius: 10px;
        padding: 20px;
        max-height: 500px;
        overflow-y: auto;
    }

    .segments-panel h3 {
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #3498db;
        position: sticky;
        top: 0;
        background-color: #1a2530;
        padding-bottom: 10px;
    }

    .segments-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .segment-item {
        padding: 15px;
        background-color: rgba(40, 55, 75, 0.6);
        border-radius: 8px;
        border-left: 4px solid #2c3e50;
    }

    .segment-item.active {
        border-left-color: #3498db;
        background-color: rgba(52, 152, 219, 0.1);
    }

    .segment-text {
        margin-bottom: 10px;
        line-height: 1.5;
    }

    .segment-details {
        display: flex;
        justify-content: space-between;
        font-size: 0.9rem;
        color: #95a5a6;
    }

    .segment-subject, .segment-emotion {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    footer {
        padding: 25px 40px;
        background-color: rgba(20, 30, 45, 0.9);
        border-top: 1px solid #34495e;
        text-align: center;
    }

    footer p {
        margin-bottom: 15px;
        color: #95a5a6;
    }

    .features {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 25px;
        font-size: 0.95rem;
    }

    .features span {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .features i {
        color: #2ecc71;
    }
</style>
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
