Simple Roku Scene Graph channel containing an empty scene.
Brighterscript version ^0.65.2

Setup Instructions:
- Clone repo
- Checkout node-brighterscript branch
- Run npm install or yarn
- Open sourcecode using vscode
- Goto Run And Debug
- Make sure "Brightscript Debug: Launch" confir is selected and click Start Debugging
- The package will be zipped and uploaded to Roku automatically(you may receive prompts for your roku device details if roku-deploy is not configured already)



===================================> VSCode launch json <===================================

{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "BrightScript Debug: Launch",
            "type": "brightscript",
            "request": "launch",
            "host": "10.1.209.165",
            "password": "123123",
            "rootDir": "${workspaceFolder}/dist",
            "preLaunchTask": "build"
        }
    ]
}


===================================> VSCode settings json <===================================

{
    "files.exclude": {
        "**/.git": true,
        "**/.svn": true,
        "**/.hg": true,
        "**/CVS": true,
        "**/.DS_Store": true,
        "**/Thumbs.db": true,
        "**/node_modules": true
    },
    "brightscript.bsdk": "./node_modules/brighterscript"
}


===================================> VSCode tasks json <===================================

{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build",
            "type": "shell",
            "command": "npx bsc"
        }
    ]
}



EOF