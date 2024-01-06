// Copyright 2021 Alexey Varfolomeev <varlesh@gmail.com>
// Used sources & ideas:
// - Michail Vourlakos from https://github.com/psifidotos/applet-latte-sidebar-button
// - Jakub Lipinski from https://gitlab.com/divinae/uswitch

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    
    property bool showLogout: plasmoid.configuration.showLogout
    property bool showLockscreen: plasmoid.configuration.showLockscreen
    property bool showSuspend: plasmoid.configuration.showSuspend
    property bool showHibernate: plasmoid.configuration.showHibernate
    property bool showReboot: plasmoid.configuration.showReboot
    property bool showKexec: plasmoid.configuration.showKexec
    property bool showShutdown: plasmoid.configuration.showShutdown

    Layout.fillWidth: true
    Layout.fillHeight: true
    width: 180
    height: 180

    compactRepresentation: Item {
        Kirigami.Icon {
            anchors.fill: parent
            source: "system-shutdown"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            onClicked: {
                expanded = !expanded
            }
        }
    }

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    function action_logOut() {
        expanded = false
        executable.exec('qdbus org.kde.Shutdown /Shutdown  org.kde.Shutdown.logout')
    }

    function action_reBoot() {
        expanded = false
        executable.exec('qdbus org.kde.Shutdown /Shutdown  org.kde.Shutdown.logoutAndReboot')
    }

    function action_kexec() {
        expanded = false
        executable.exec('qdbus --system org.freedesktop.systemd1 /org/freedesktop/systemd1 org.freedesktop.systemd1.Manager.StartUnit kexec.target replace-irreversibly')
    }
    
    function action_lockScreen() {
        expanded = false
        executable.exec('qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock')
    }

    function action_shutDown() {
        expanded = false
        executable.exec('qdbus org.kde.Shutdown /Shutdown  org.kde.Shutdown.logoutAndShutdown')
    }
    
    function action_susPend() {
        expanded = false
        executable.exec('qdbus org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Suspend')
    }
    
    function action_hiberNate() {
        expanded = false
        executable.exec('qdbus org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Hibernate')
    }

    PlasmaExtras.Highlight {
        id: delegateHighlight
        visible: false
         hovered: true
        z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
    }

    fullRepresentation: Item {
        
        Layout.fillWidth: false
        Layout.fillHeight: false
        Layout.preferredWidth: plasmoid.configuration.width
        Layout.preferredHeight: plasmoid.configuration.height

        ColumnLayout {
            id: column
            anchors.fill: parent

            spacing: 0
            
            ListDelegate {
                id: logoutButton
                text: i18n("Logout")
                highlight: delegateHighlight
                icon: "system-log-out"
                onClicked: action_logOut()
                visible: showLogout
            }
            ListDelegate {
                id: lockButton
                text: i18n("Lock Screen")
                highlight: delegateHighlight
                icon: "system-lock-screen"
                onClicked: action_lockScreen()
                visible: showLockscreen
            }
            ListDelegate {
                id: suspendButton
                text: i18n("Suspend")
                highlight: delegateHighlight
                icon: "system-suspend"
                onClicked: action_susPend()
                visible: showSuspend
            }

            ListDelegate {
                id: hibernateButton
                text: i18n("Hibernate")
                highlight: delegateHighlight
                icon: "system-suspend-hibernate"
                onClicked: action_hiberNate()
                visible: showHibernate
            }

            ListDelegate {
                id: rebootButton
                text: i18n("Reboot")
                highlight: delegateHighlight
                icon: "system-reboot"
                onClicked: action_reBoot()
                visible: showReboot
            }

            ListDelegate {
                id: kexecButton
                text: i18n("Kexec Reboot")
                highlight: delegateHighlight
                icon: "system-reboot"
                onClicked: action_kexec()
                visible: showKexec
            }

            ListDelegate {
                id: shutdownButton
                text: i18n("Shutdown")
                highlight: delegateHighlight
                icon: "system-shutdown"
                onClicked: action_shutDown()
                visible: showShutdown
            }
        }
    }
}
