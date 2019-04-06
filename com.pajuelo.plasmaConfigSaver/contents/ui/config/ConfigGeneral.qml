/*
 * Copyright 2019 Jason Lim (yuenhoe86@gmail.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    property alias cfg_widgetWidth: widgetWidth.value
    property alias cfg_targetfolder: targetfolder.text

    property var mediumSpacing: 1.5*units.smallSpacing

    GridLayout {
        columns: 2

        Label {
            text: i18n('Target folder (full path):')
        }
        
        TextField {
            id: targetfolder
            Layout.preferredWidth: parent.width
        }

        Label {
            text: i18n('Widget width:')
        }

        SpinBox {
            id: widgetWidth
            minimumValue: units.iconSizes.medium + 2*mediumSpacing
            maximumValue: 1000
            decimals: 0
            stepSize: 10
            suffix: ' px'
        }
    }
}
