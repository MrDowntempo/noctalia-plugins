import Qt.labs.folderlistmodel
import QtQuick
import Quickshell
import Quickshell.Io

import qs.Commons
import qs.Services.UI

import "./main"

Item {
    id: root
    property var pluginApi: null

    readonly property bool active: 
        pluginApi.pluginSettings.active || 
        false

    readonly property string currentWallpaper: 
        pluginApi.pluginSettings.currentWallpaper || 
        ""

    readonly property bool isMuted:
        pluginApi.pluginSettings.isMuted ||
        false

    readonly property bool isPlaying:
        pluginApi.pluginSettings.isPlaying ||
        false

    readonly property string mpvSocket: 
        pluginApi.pluginSettings.mpvSocket || 
        pluginApi.manifest.metadata.defaultSettings.mpvSocket || 
        "/tmp/mpv-socket"

    readonly property var oldWallpapers:
        pluginApi.pluginSettings.oldWallpapers || 
        ({})

    readonly property bool thumbCacheReady:
        pluginApi.pluginSettings.thumbCacheReady ||
        false

    readonly property real volume:
        pluginApi.pluginSettings.volume ||
        100

    readonly property string wallpapersFolder: 
        pluginApi.pluginSettings.wallpapersFolder || 
        pluginApi.manifest.metadata.defaultSettings.wallpapersFolder || 
        "~/Pictures/Wallpapers"




    /***************************
    * WALLPAPER FUNCTIONALITY
    ***************************/
    function random() {
        if (wallpapersFolder === "" || folderModel.count === 0) {
            Logger.e("mpvpaper", "Empty wallpapers folder or no files found!");
            return;
        }

        const rand = Math.floor(Math.random() * folderModel.count);
        const url = folderModel.get(rand, "filePath");
        setWallpaper(url);
    }

    function clear() {
        setWallpaper("");
    }

    function setWallpaper(path) {
        if (root.pluginApi == null) {
            Logger.e("mpvpaper", "Can't set the wallpaper because pluginApi is null.");
            return;
        }

        pluginApi.pluginSettings.currentWallpaper = path;
        pluginApi.saveSettings();
    }

    function setActive(isActive) {
        if(root.pluginApi == null) {
            Logger.e("mpvpaper", "Can't change active state because pluginApi is null.");
            return;
        }

        pluginApi.pluginSettings.active = isActive;
        pluginApi.saveSettings();
    }


    /***************************
    * PLAYBACK FUNCTIONALITY
    ***************************/
    function resume() {
        if (pluginApi == null) return;

        pluginApi.pluginSettings.isPlaying = true;
        pluginApi.saveSettings();
    }

    function pause() {
        if (pluginApi == null) return;

        pluginApi.pluginSettings.isPlaying = false;
        pluginApi.saveSettings();
    }

    function togglePlaying() {
        if (pluginApi == null) return;

        pluginApi.pluginSettings.isPlaying = !root.isPlaying;
        pluginApi.saveSettings();
    }


    /***************************
    * AUDIO FUNCTIONALITY
    ***************************/
    function mute() {
        if (pluginApi == null) return;

        pluginApi.pluginSettings.isMuted = true;
        pluginApi.saveSettings();
    }

    function unmute() {
        if (pluginApi == null) return;

        pluginApi.pluginSettings.isMuted = false;
        pluginApi.saveSettings();
    }

    function toggleMute() {
        if (pluginApi == null) return;

        pluginApi.pluginSettings.isMuted = !root.isMuted;
        pluginApi.saveSettings();
    }

    function setVolume(volume) {
        if (pluginApi == null) return;

        pluginApi.pluginSettings.volume = volume;
        pluginApi.saveSettings();
    }

    function increaseVolume() {
        if (pluginApi == null) return;

        setVolume(root.volume + Settings.data.audio.volumeStep);
    }

    function decreaseVolume() {
        if (pluginApi == null) return;

        setVolume(root.volume - Settings.data.audio.volumeStep);
    }

    /***************************
    * HELPER FUNCTIONALITY
    ***************************/
    function getThumbPath(videoPath: string): string {
        return thumbnails.getThumbPath(videoPath);
    }

    // Get thumbnail url based on video name
    function getThumbUrl(videoPath: string): string {
        return thumbnails.getThumbUrl(videoPath);
    }

    function thumbRegenerate() {
        thumbnails.thumbRegenerate();
    }

    /***************************
    * COMPONENTS
    ***************************/
    Mpvpaper {
        // Contains all the mpvpaper specific functionality
        id: mpvpaper
        pluginApi: root.pluginApi

        active: root.active
        currentWallpaper: root.currentWallpaper
        isMuted: root.isMuted
        isPlaying: root.isPlaying
        mpvSocket: root.mpvSocket
        volume: root.volume

        thumbnails: thumbnails
        innerService: innerService
    }

    Thumbnails {
        // Contains all the thumbnail specific functionality
        id: thumbnails
        pluginApi: root.pluginApi

        currentWallpaper: root.currentWallpaper
        thumbCacheReady: root.thumbCacheReady

        folderModel: folderModel
    }

    InnerService {
        // Contains all the save / load functionality for this to work with noctalia
        id: innerService
        pluginApi: root.pluginApi

        currentWallpaper: root.currentWallpaper
        oldWallpapers: root.oldWallpapers

        thumbnails: thumbnails
    }


    FolderListModel {
        id: folderModel
        folder: root.pluginApi == null ? "" : "file://" + root.wallpapersFolder
        nameFilters: ["*.mp4", "*.avi", "*.mov"]
        showDirs: false

        onStatusChanged: {
            if (folderModel.status == FolderListModel.Ready) {
                // Generate all the thumbnails for the folder
                thumbnails.thumbGeneration();
            }
        }
    }

    // IPC Handler
    IpcHandler {
        target: "plugin:mpvpaper"

        function random() {
            root.random();
        }

        function clear() {
            root.clear();
        }

        function setWallpaper(path: string) {
            root.setWallpaper(path);
        }

        function getWallpaper(): string {
            return root.currentWallpaper;
        }

        function setActive(isActive: bool) {
            root.setActive(isActive);
        }

        function getActive(): bool {
            return root.active;
        }

        function toggleActive() {
            root.setActive(!root.active);
        }

        function resume() {
            root.resume();
        }

        function pause() {
            root.pause();
        }

        function togglePlaying() {
            root.togglePlaying();
        }

        function mute() {
            root.mute();
        }

        function unmute() {
            root.unmute();
        }

        function toggleMute() {
            root.toggleMute();
        }

        function setVolume(volume: real) {
            root.setVolume(volume);
        }

        function increaseVolume() {
            root.increaseVolume();
        }

        function decreaseVolume() {
            root.decreaseVolume();
        }
    }
}
