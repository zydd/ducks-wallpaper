import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root
    width: 1366/2
    height: 768/2
    focus: true

    property point c: Qt.point(-0.737253,4.298468)
    property point dc: Qt.point(0,0)
    property int iter: 152
    property real esc: 64
    property int pre: 0
    property real col: 0.98136
    property real zoom: 9.994168246578434
    property real dzoom: 1
    property point pos: Qt.point(299.367, 11.1381)
    property point dpos: Qt.point(0,0)

    layer.enabled: true
    layer.effect: ShaderEffect {
        property real ratio: root.width/root.height
        property point c: root.c
        property int iter: root.iter
        property real esc: root.esc
        property int pre: root.pre
        property real col: root.col
        property real zoom: root.zoom
        property point pos: root.pos

        fragmentShader: 'file:///home/zyd/.local/share/plasma/wallpapers/Ducks/contents/ui/ducks.frag'
    }

    Keys.onPressed: {
        if(event.isAutoRepeat)
            return
            switch(event.key) {
                case Qt.Key_Up: dc.y = 0.0001; move.move_start(); break
                case Qt.Key_Down: dc.y = -0.0001; move.move_start(); break
                case Qt.Key_Left: dc.x = -0.0001; move.move_start(); break
                case Qt.Key_Right: dc.x = 0.0001; move.move_start(); break
                case Qt.Key_W: dpos.y = 0.02; move.move_start(); break
                case Qt.Key_S: dpos.y = -0.02; move.move_start(); break
                case Qt.Key_A: dpos.x = -0.02; move.move_start(); break
                case Qt.Key_D: dpos.x = 0.02; move.move_start(); break
                case Qt.Key_Z:
                case Qt.Key_PageUp: dzoom = 1.02; move.move_start(); break
                case Qt.Key_X:
                case Qt.Key_PageDown: dzoom = 1/1.02; move.move_start(); break
        }
    }

    MouseArea {
        id: ma
        property point last
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons

        onDoubleClicked: {
            c = Qt.point(-0.557263, 3.82191)
            zoom = 9.994168246578434
            pos = Qt.point(299.367, 11.1381)
        }

        onPressed: {
            last = Qt.point(mouse.x, mouse.y)
            if (mouse.button != Qt.LeftButton)
                move.move_start()
        }

        onPositionChanged: {
            switch (mouse.buttons) {
            case Qt.LeftButton:
                pos.x -= 2*(mouse.x - last.x)*zoom/root.height
                pos.y += 2*(mouse.y - last.y)*zoom/root.height
                last = Qt.point(mouse.x, mouse.y)
                break
            case Qt.MiddleButton:
                dc.x = 0.00005*Math.atan(4*(mouse.x - last.x)/root.width)
                dc.y = -0.00005*Math.atan(4*(mouse.y - last.y)/root.height)
                break
            case Qt.RightButton:
                dzoom = 1-0.3*(-mouse.x + mouse.y + last.x - last.y)/(root.width + root.height)
                break
            }
        }

        onReleased: {
            if (! (mouse.buttons & Qt.MiddleButton)) {
                dc = Qt.point(0,0)
                move.move_stop()
            }
            if (! (mouse.buttons & Qt.RightButton)) {
                dzoom = 1
                move.move_stop()
            }
        }
    }

    Keys.onReleased: {
        if(event.isAutoRepeat)
            return
        switch(event.key) {
            case Qt.Key_Up: dc.y = 0; move.move_stop(); break
            case Qt.Key_Down: dc.y = 0; move.move_stop(); break
            case Qt.Key_Left: dc.x = 0; move.move_stop(); break
            case Qt.Key_Right: dc.x = 0; move.move_stop(); break
            case Qt.Key_W: dpos.y = 0; move.move_stop(); break
            case Qt.Key_S: dpos.y = 0; move.move_stop(); break
            case Qt.Key_A: dpos.x = 0; move.move_stop(); break
            case Qt.Key_D: dpos.x = 0; move.move_stop(); break
            case Qt.Key_Z:
            case Qt.Key_PageUp: dzoom = 1; move.move_stop(); break
            case Qt.Key_X:
            case Qt.Key_PageDown: dzoom = 1; move.move_stop(); break
        }
    }

    Timer {
        property int count: 0
        id: move
        running: false
        repeat: true
        interval: 16
        onTriggered: {
            if (ma.pressedButtons & Qt.RightButton) {
                var zx = pos.x - (root.width - 2*ma.last.x)/root.height * zoom
                var zy = pos.y + (root.height - 2*ma.last.y)/root.height * zoom

                pos.x = zx + (pos.x - zx) * dzoom
                pos.y = zy + (pos.y - zy) * dzoom
            }
            zoom *= dzoom
            c.x += dc.x
            c.y += dc.y
            pos.x += dpos.x * zoom
            pos.y += dpos.y * zoom
        }

        function move_start() {
            running = true
            count += 1
        }

        function move_stop() {
            count -= 1
            if (count <= 0) {
                count = 0
                running = false
                print('c:', c, 'pos:', pos, 'zoom:', zoom)
            }
        }
    }
}
