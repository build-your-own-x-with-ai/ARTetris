# AR Tetris

[English](#english) | [中文](#chinese)

<a name="english"></a>
## English

An Augmented Reality Tetris game built with iOS RealityKit and SwiftUI. Bring the classic Tetris gameplay into the real world!

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
![ARKit](https://img.shields.io/badge/AR-RealityKit-blue.svg)

### Screenshots

![ARTetris](ARTetris.png)

### ✨ Features

*   **Immersive AR Experience**: The game board floats directly in front of the camera, following your head movement (Head-Locked), playable anywhere.
*   **Classic Gameplay**: Includes all 7 standard Tetrominoes (I, J, L, O, S, T, Z) with authentic rules.
*   **3D Visuals**: Blocks are rendered as 3D entities with a semi-transparent blue boundary box for clear visibility even in empty space.
*   **Complete Audio**: Integrated Background Music (BGM) and sound effects for movement, rotation, line clearing, and game over.
*   **Intuitive Controls**: Large virtual buttons at the bottom of the screen (Left, Right, Rotate, Hard Drop) for smooth operation.
*   **Preview System**: Supports Next Piece preview and real-time score display.

### 🛠 Tech Stack

*   **Language**: Swift
*   **UI Framework**: SwiftUI
*   **AR Engine**: RealityKit, ARKit
*   **Audio**: AVFoundation
*   **IDE**: Xcode

### 🚀 How to Run

#### 1. Prerequisites
*   Mac (Xcode 15 or higher)
*   iPhone or iPad (iOS 15+, ARKit support required)
*   *Note: Due to camera and AR dependencies, this project cannot run fully on the iOS Simulator. Please use a physical device.*

#### 2. Audio Configuration
The project includes a `generate_audio.py` script to generate necessary sound effects.
If the `ARTetris/` directory does not contain `.wav` files yet, run the script first:
```bash
python3 generate_audio.py
```
**Important**: Ensure the generated `.wav` files (bgm.wav, move.wav, etc.) are added to the Xcode project:
1.  Open Xcode.
2.  Drag and drop the `.wav` files from the `ARTetris/` folder into the Project Navigator on the left.
3.  In the dialog, make sure **"Add to targets"** is checked for **ARTetris**.

#### 3. Build & Install
1.  Connect your iPhone/iPad to your Mac via cable.
2.  Select your device as the run destination in Xcode.
3.  Click Run (or press `Cmd + R`).
4.  Allow **Camera Access** when opening the App for the first time.

### 🎮 Controls

*   **Start Game**: Tap the blue button in the center to start.
*   **⬅️ Left Arrow**: Move block left.
*   **➡️ Right Arrow**: Move block right.
*   **🔄 Rotate Icon (Yellow)**: Rotate block clockwise.
*   **⬇️ Down Arrow**: Hard Drop (Instantly drop and lock the block).

### 📂 File Structure

```text
ARTetris/
├── ARTetrisApp.swift      # App Entry Point (App Lifecycle)
├── ContentView.swift      # Main View, containing RealityView (AR) and 2D UI Overlay
├── TetrisGame.swift       # Core Game Logic (Grid data, collision detection, state management)
├── Tetromino.swift        # Tetromino Definitions (Shapes, colors, rotation logic)
├── AudioManager.swift     # Audio Manager (BGM and SFX playback)
├── generate_audio.py      # Audio Generation Script (Python)
└── *.wav                  # Game Audio Assets
```

---

<a name="chinese"></a>
## 中文 (Chinese)

基于 iOS RealityKit 和 SwiftUI 构建的增强现实俄罗斯方块游戏。将经典的俄罗斯方块玩法带入真实世界！

### ✨ 特性 (Features)

*   **AR 沉浸式体验**: 游戏棋盘悬浮在相机正前方，跟随用户视角移动 (Head-Locked)，随时随地可玩。
*   **经典玩法**: 包含 7 种标准方块 (Tetrominoes: I, J, L, O, S, T, Z)，完美复刻经典规则。
*   **3D 视觉效果**: 方块以 3D 实体渲染，配有半透明的蓝色边界框，即使在空旷区域也能清晰定位。
*   **完整音效**: 集成背景音乐 (BGM) 及移动、旋转、消除、游戏结束等音效。
*   **直观控制**: 屏幕下方提供大尺寸虚拟按键 (左移、右移、旋转、硬降)，操作手感流畅。
*   **预览功能**: 支持下一个方块预览 (Next Piece) 和实时分数显示。

### 🛠 技术栈 (Tech Stack)

*   **编程语言**: Swift
*   **UI 框架**: SwiftUI
*   **AR 引擎**: RealityKit, ARKit
*   **音频处理**: AVFoundation
*   **开发工具**: Xcode

### 🚀 如何运行 (How to Run)

#### 1. 环境准备
*   Mac 电脑 (安装 Xcode 15 或更高版本)
*   iPhone 或 iPad (iOS 15+, 需支持 ARKit)
*   *注意: 由于依赖摄像头和 AR 功能，本项目无法在 iOS 模拟器上完整运行，请使用真机调试。*

#### 2. 音频资源配置
项目包含一个 `generate_audio.py` 脚本用于生成游戏所需的音效文件。
如果 `ARTetris/` 目录下尚未包含 `.wav` 文件，请先运行脚本：
```bash
python3 generate_audio.py
```
**重要**: 确保生成的 `.wav` 文件 (bgm.wav, move.wav 等) 已经被引入到 Xcode 项目中：
1.  打开 Xcode。
2.  将 `ARTetris/` 目录下的 `.wav` 文件拖拽到 Xcode 左侧的项目导航栏中。
3.  在弹出的对话框中，确保勾选 **"Add to targets"** 中的 **ARTetris**。

#### 3. 编译与安装
1.  使用数据线连接 iPhone/iPad 到 Mac。
2.  在 Xcode 顶部选择你的设备作为运行目标。
3.  点击运行按钮 (或按 `Cmd + R`)。
4.  在真机上首次打开 App 时，请允许 **相机权限**。

### 🎮 操作指南 (Controls)

*   **Start Game**: 点击屏幕中央的蓝色按钮开始游戏。
*   **⬅️ 左箭头**: 向左移动方块。
*   **➡️ 右箭头**: 向右移动方块。
*   **🔄 旋转图标 (黄色)**: 顺时针旋转方块。
*   **⬇️ 下箭头**: 硬降 (Hard Drop)，使方块瞬间落到底部锁定。

### 📂 项目结构 (File Structure)

```text
ARTetris/
├── ARTetrisApp.swift      # 应用入口 (App Lifecycle)
├── ContentView.swift      # 主界面，包含 AR 视图 (RealityView) 和 2D UI 覆盖层
├── TetrisGame.swift       # 核心游戏逻辑 (Grid 数据、碰撞检测、状态管理)
├── Tetromino.swift        # 方块定义 (形状坐标、颜色、旋转逻辑)
├── AudioManager.swift     # 音频管理器 (播放 BGM 和音效)
├── generate_audio.py      # 音效生成脚本 (Python)
└── *.wav                  # 游戏音效资源
```

### 📝 开发笔记

*   **坐标系转换**: 游戏逻辑使用经典的 2D 网格坐标 (0,0 在左上角)，而 RealityKit 使用 3D 世界坐标 (Y 轴向上)。渲染层负责将逻辑坐标映射到 3D 空间位置。
*   **AR Anchor**: 使用了 `.camera` Anchor，使游戏内容始终保持在用户视野前方固定距离，避免了平面检测 (Plane Detection) 的不稳定性。
