How to produce .exe and .apk automatically using GitHub Actions
---------------------------------------------------------------

1) Create a new GitHub repository (private or public).

2) Push the entire contents of the unzipped 'transport_builds' folder to that repository's root.
   (This folder contains two subprojects: electron-react-app/ and flutter-app/)

3) Make sure the branch name is 'main' (or edit .github/workflows/build-artifacts.yml to match your default branch).

4) Open the repository on GitHub -> Actions tab. You should see the 'Build TransportSync' workflow.
   Click 'Run workflow' (or push a commit to main) to trigger a build.

5) After the workflow completes you'll find two artifacts:
   - electron-artifacts  -> contains the electron dist output (installer or exe)
   - flutter-apk         -> contains the built Android APK (app-release.apk)

Notes & requirements:
- The Electron build uses 'electron-builder' and runs on 'windows-latest' runner. The produced installer will appear in electron-react-app/dist/. 
- Code signing is optional. If you have a code-signing certificate and want to sign the installer automatically, add secrets CSC_LINK and CSC_KEY_PASSWORD to your GitHub repo secrets. Otherwise the installer will be unsigned.
- The Flutter build uses the standard Flutter toolchain on Ubuntu to produce an APK. If the build fails due to Android SDK license issues, ensure Actions accepted licenses; the workflow already attempts to accept licenses.
- If you prefer, I can help push this repo to GitHub for you and trigger the workflow; for that I'll need repository creation permission or you can invite me/copy the files yourself.

If you'd like, I can now prepare a single ZIP that includes this workflow (already done). After you push and run the workflow on GitHub, you will get the final .exe and .apk files as downloadable artifacts.
