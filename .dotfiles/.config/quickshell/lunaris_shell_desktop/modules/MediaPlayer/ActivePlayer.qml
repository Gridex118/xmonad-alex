pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    property int activeIndex: 0
    readonly property list<MprisPlayer> playerList: Mpris.players.values
        .filter(player => !player.dbusName.endsWith("playerctld"))
    property MprisPlayer selectedPlayer: (playerList.length > 0)?
        playerList[activeIndex] : null

    readonly property MprisPlayer player: selectedPlayer
    readonly property string name: player?.identity ?? ""
    readonly property string dbusName: player?.dbusName ?? ""
    readonly property string trackTitle: player?.trackTitle ?? ""

    readonly property real trackLength: player?.length ?? 1
    property real trackPosition: player?.position ?? 0

    function seekPosition(value) {
        if (player) {
            player.position = value;
        }
    }

    function isPlaying() {
        return player?.playbackState === MprisPlaybackState.Playing
    }

    function cyclePlayer() {
        activeIndex = (activeIndex + 1) % playerList.length;
    }

    onPlayerListChanged: {
        if (dbusName !== "") {
            const index = playerList
                .findIndex(player => player.dbusName === dbusName);
            activeIndex = (index !== -1)? index : 0;
        } else {
            activeIndex = 0;
        }
    }

    onPlayerChanged: {
        if (player) {
            player.positionChanged();
        }
    }
}
