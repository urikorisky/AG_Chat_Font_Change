# Guide: Increase Agent Chat Font Size in Google AntiGravity 2.12.2 (Windows)

This guide provides a working workaround to increase the default font size of the central agent chat and conversation area in **Google AntiGravity v2.12.2**. 

Because AntiGravity compiles its user interface using dynamic class obfuscation and bundles everything inside a single local web thread (`https://127.0.0.1`), standard static CSS injection and geometric screen position tracking fail when layout panels are opened, closed, or resized. The working solution uses a client-side layout structural scanner script that safely targets chat elements while leaving code editors and navigation trees completely untouched.

> **Warning:** This solution has been explicitly tested for **AntiGravity version 2.12.2 only**. Future updates may change file structures or entry points.

---

## 🛠 Method 1: Automated Patcher (Fastest & Easiest)

If you don't want to dig through code files manually, you can use the automated script included in this repository to verify, unpack, patch, and rebuild the software for you.

### Steps to Run:
1. Ensure you have **Node.js** installed on your system (Required to unpack the application containers). If you do not have it, download the "LTS" version from [nodejs.org](https://nodejs.org).
2. Completely close **AntiGravity**.
3. Download and double-click **`patch_antigravity_font.bat`** from this repository.
4. A Command Prompt window will appear, execute the file analysis checklist, inject the font fixer, and close out automatically upon displaying a `[SUCCESS]` read-out.
5. Relaunch AntiGravity to see your scaled layout.

---

## ⚡ Method 2: Abbreviated Manual Patch (For Advanced Users)

If you are already familiar with Node.js, `npm`, and `asar` archives, use this quick checklist:

1. Navigate to `%LOCALAPPDATA%\Programs\Antigravity\resources\`.
2. Extract the app bundle:  
   ```bash
   asar extract app.asar app-working
   ```
3. Open `app-working\dist\main.js`.
4. Append the following layout structural scanner logic directly to the bottom of the file:

```javascript
// Structural Layout Font Adjuster for AntiGravity 2.12.2
const { app: electronApp } = require('electron');
function injectLayoutFontSize(contents) {
  const script = `
    setInterval(() => {
      const textElements = document.querySelectorAll('p, span, code, pre, button, li, td, th');
      textElements.forEach(el => {
        if (el.closest('.antigravity-left-nav') || el.closest('[class*="sidebar"]') || el.closest('[class*="left-panel"]')) return;
        if (el.closest('.monaco-editor') || el.closest('[class*="editor"]') || el.closest('[class*="document-viewer"]')) return;
        el.style.setProperty('font-size', '16px', 'important');
        el.style.setProperty('line-height', '1.5', 'important');
        if (el.tagName === 'TD' || el.tagName === 'TH' || el.tagName === 'CODE') {
          el.style.setProperty('font-size', '14px', 'important');
        }
      });
    }, 1000);
  `;
  contents.executeJavaScript(script).catch(() => {});
}
electronApp.whenReady().then(() => {
  electronApp.on('web-contents-created', (event, contents) => {
    contents.on('did-finish-load', () => injectLayoutFontSize(contents));
    contents.on('dom-ready', () => injectLayoutFontSize(contents));
  });
});
```
5. Re-bundle the application package:  
   ```bash
   asar pack app-working app.asar
   ```
6. Relaunch AntiGravity.

---

## 📘 Method 3: Comprehensive Manual Patch (Beginner Friendly)

Follow these steps if you prefer to manually copy the changes without script tools.

### Prerequisites: Setting up the Tools
Before changing any files, your computer needs to understand the archive commands we will be using.
1. Download and install **Node.js** (choose the "LTS" version) from the official site: [nodejs.org](https://nodejs.org).
2. Run the installer wizard, keep clicking **Next** with all default options selected, and finish the installation.

### Step 1: Open the Hidden Installation Folder
1. Press the **Windows Key + R** on your keyboard to open the "Run" dialog box.
2. Copy and paste the following text into the box and press **Enter**:
   ```text
   %LOCALAPPDATA%\Programs\Antigravity\resources
   ```
3. A Windows File Explorer window will open showing a file named `app.asar`.

### Step 2: Open the Command Window
1. Click on an empty white space inside the top pathway address bar so the text highlights.
2. Type **`cmd`** and hit **Enter** to initialize a localized terminal console.

### Step 3: Extract the Hidden Application Files
1. Inside the black command box, execute this command to install the archiver utility:
   ```bash
   npm install -g @electron/asar
   ```
2. Next, extract the hidden package files into a working folder:
   ```bash
   asar extract app.asar app-working
   ```
3. A brand new directory folder named **`app-working`** will appear in File Explorer.

### Step 4: Add the Scaling Code
1. Open **`app-working\dist\`** and open the file named **`main.js`** using **Notepad**.
2. Scroll to the **very bottom line** of the file, create a new line, and paste the code from **Method 2**.
3. Save and close the file.

### Step 5: Repack and Lock the Changes
1. Go back to your open black Command Prompt window and execute the compiler command:
   ```bash
   asar pack app-working app.asar
   ```
2. Close out your windows and open **AntiGravity**. Your text size in the chat view will dynamically upscale to a clean **16px**, adapting perfectly whether your layout sidebars are opened or closed!

---

## Behind the Scenes: How the Fix Works

Unlike typical applications where you can find static CSS theme properties (like `.chat-box { font-size: 16px; }`), AntiGravity packages its layout inside dynamic framework components. This breaks typical CSS targets and makes the codebase unreadable. 

To bypass this without breaking your critical code editor windows, the logic checks your app's layout architecture frame-by-frame:
1. **Target Gathering (`querySelectorAll`):** Every second, the script looks at every paragraph, text snippet, list item, and table block active on your view canvas.
2. **Left Panel Protection (`.closest`):** It looks up the parent structure of each item. If the text lives inside the far-left system menu or settings layouts, it skips it to protect global app buttons from breaking.
3. **Editor Canvas Protection (`.monaco-editor`):** It checks if the text snippet lives inside an engineering workspace view or an open implementation doc file tab. If yes, it skips it to preserve your default code scaling.
4. **Enforcing Layout Sizing (`.style.setProperty`):** Anything left over must belong to the central chat system stream. The script forces a clean, custom `font-size` style variable directly onto the plain text, scaling font elements cleanly in real-time as responses stream down!
