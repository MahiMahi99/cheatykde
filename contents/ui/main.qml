// Cheaty KDE - Version corrigée sans chevauchement
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    
    property string cheatsheetFolder: Qt.resolvedUrl("../refdocs").toString().replace("file://", "")
    property var loadedSheets: []
    property var currentSheet: null
    property string currentSection: ""
    property string currentSheetName: "Sélectionnez un cheatsheet"
    property int currentSheetIndex: -1
    
    // Modèle pour le contenu avec sections repliables
    property ListModel contentModel: ListModel {}
    property var expandedSections: ({})
    
    preferredRepresentation: compactRepresentation
    toolTipMainText: "Cheaty KDE"
    toolTipSubText: loadedSheets.length + " cheatsheets disponibles"
    
    // Icône personnalisée - utilise le chemin relatif correct
    property string customIcon: Qt.resolvedUrl("../cheatykde.svg")
    
    Component.onCompleted: {
        console.log("🚀 Cheaty KDE démarré");
        console.log("📍 Chemin de l'icône:", Qt.resolvedUrl("../cheatykde.svg"));
        loadCheatsheets();
    }
    
    // ============== ICÔNE DANS LA BARRE ==============
    compactRepresentation: MouseArea {
        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
        
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        
        Kirigami.Icon {
            anchors.fill: parent
            source: root.customIcon.length > 0 ? root.customIcon : "accessories-text-editor"
            active: parent.containsMouse
            scale: parent.containsMouse ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 150 } }
        }
        
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                root.expanded = !root.expanded;
            } else if (mouse.button === Qt.MiddleButton) {
                loadCheatsheets();
            }
        }
    }
    
    // ============== INTERFACE ÉTENDUE ==============
    fullRepresentation: Item {
        Layout.minimumWidth: 700
        Layout.minimumHeight: 500
        Layout.preferredWidth: 900
        Layout.preferredHeight: 600
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                Kirigami.Icon {
                    source: root.customIcon.length > 0 ? root.customIcon : "accessories-text-editor"
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                }
                
                Kirigami.Heading {
                    text: "Cheaty KDE"
                    level: 1
                    Layout.fillWidth: true
                }
                
                PlasmaComponents.Button {
                    icon.name: "view-refresh"
                    text: "Recharger"
                    onClicked: root.loadCheatsheets()
                }
            }
            
            Kirigami.Separator {
                Layout.fillWidth: true
            }
            
            // Navigation par liste et contenu avec SplitView
            SplitView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                orientation: Qt.Horizontal
                
                // Liste des cheatsheets avec largeur fixe
                Item {
                    SplitView.minimumWidth: 200
                    SplitView.preferredWidth: 250
                    SplitView.maximumWidth: 300
                    
                    ColumnLayout {
                        anchors.fill: parent
                        
                        PlasmaComponents.Label {
                            text: "Cheatsheets (" + root.loadedSheets.length + ")"
                            font.bold: true
                        }
                        
                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ListView {
                                id: sheetsList
                                model: root.loadedSheets
                                currentIndex: root.currentSheetIndex
                                
                                delegate: ItemDelegate {
                                    width: ListView.view.width
                                    height: 50
                                    
                                    highlighted: ListView.isCurrentItem
                                    
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 10
                                        
                                        Image {
                                            Layout.preferredWidth: 32
                                            Layout.preferredHeight: 32
                                            source: modelData.iconPath ? "file://" + modelData.iconPath : ""
                                            sourceSize: Qt.size(32, 32)
                                            fillMode: Image.PreserveAspectFit
                                            
                                            // Fallback icon si pas d'image
                                            Kirigami.Icon {
                                                anchors.fill: parent
                                                source: "text-x-generic"
                                                visible: parent.status !== Image.Ready
                                            }
                                        }
                                        
                                        PlasmaComponents.Label {
                                            text: modelData.name || "Sans nom"
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                    }
                                    
                                    onClicked: {
                                        // Si on clique sur le même, on ferme
                                        if (sheetsList.currentIndex === index) {
                                            sheetsList.currentIndex = -1;
                                            root.currentSheetIndex = -1;
                                            root.currentSheetName = "Sélectionnez un cheatsheet";
                                            root.contentModel.clear();
                                        } else {
                                            sheetsList.currentIndex = index;
                                            root.currentSheetIndex = index;
                                            root.showSheetContent(modelData);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Zone de contenu
                Item {
                    SplitView.fillWidth: true
                    
                    ColumnLayout {
                        anchors.fill: parent
                        
                        PlasmaComponents.Label {
                            text: root.currentSheetName
                            font.bold: true
                            font.pixelSize: 16
                        }
                        
                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ListView {
                                id: contentListView
                                model: root.contentModel
                                spacing: 0
                                
                                delegate: Item {
                                    width: contentListView.width
                                    height: model.isSection ? 35 : (root.isSectionExpanded(model.sectionName) ? itemContent.height : 0)
                                    clip: true
                                    
                                    // Section header
                                    Rectangle {
                                        anchors.fill: parent
                                        color: model.isSection ? Kirigami.Theme.highlightColor : "transparent"
                                        opacity: model.isSection ? 0.3 : 0
                                        visible: model.isSection
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: model.isSection
                                            onClicked: {
                                                root.toggleSection(model.sectionName);
                                            }
                                        }
                                        
                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            visible: model.isSection
                                            
                                            PlasmaComponents.Label {
                                                text: model.isSection ? (root.isSectionExpanded(model.sectionName) ? "▼ " : "▶ ") + model.sectionName : ""
                                                font.bold: true
                                                Layout.fillWidth: true
                                            }
                                            
                                            PlasmaComponents.Label {
                                                text: model.isSection ? "(" + model.itemCount + " items)" : ""
                                                opacity: 0.7
                                                font.pixelSize: 12
                                            }
                                        }
                                    }
                                    
                                    // Item content
                                    Item {
                                        id: itemContent
                                        anchors.fill: parent
                                        height: model.isSection ? 0 : (itemColumn.implicitHeight + 20)
                                        visible: !model.isSection && root.isSectionExpanded(model.sectionName)
                                        
                                        ColumnLayout {
                                            id: itemColumn
                                            width: parent.width - 40
                                            anchors.left: parent.left
                                            anchors.leftMargin: 30
                                            anchors.top: parent.top
                                            anchors.topMargin: 10
                                            spacing: 5
                                            
                                            PlasmaComponents.Label {
                                                text: model.itemName || ""
                                                font.bold: true
                                                Layout.fillWidth: true
                                                visible: !model.isSection
                                            }
                                            
                                            PlasmaComponents.Label {
                                                text: model.description || ""
                                                opacity: 0.7
                                                wrapMode: Text.WordWrap
                                                Layout.fillWidth: true
                                                visible: !model.isSection && text !== ""
                                            }
                                            
                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: codeText.implicitHeight + 10
                                                color: Kirigami.Theme.alternateBackgroundColor
                                                border.color: Kirigami.Theme.textColor
                                                border.width: 1
                                                opacity: 0.8
                                                radius: 3
                                                visible: !model.isSection && model.code !== ""
                                                
                                                PlasmaComponents.Label {
                                                    id: codeText
                                                    anchors.fill: parent
                                                    anchors.margins: 5
                                                    text: model.code || ""
                                                    font.family: "monospace"
                                                    wrapMode: Text.Wrap
                                                    textFormat: Text.PlainText
                                                }
                                            }
                                            
                                            PlasmaComponents.Button {
                                                text: "📋 Copier"
                                                Layout.alignment: Qt.AlignRight
                                                visible: !model.isSection && model.code !== ""
                                                
                                                property string codeText: model.code || ""
                                                
                                                onClicked: {
                                                    root.copyToClipboard(codeText);
                                                    text = "✅ Copié!";
                                                    copiedTimer.restart();
                                                }
                                                
                                                Timer {
                                                    id: copiedTimer
                                                    interval: 2000
                                                    onTriggered: parent.text = "📋 Copier"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Barre de statut
            Kirigami.Separator {
                Layout.fillWidth: true
            }
            
            RowLayout {
                Layout.fillWidth: true
                
                PlasmaComponents.Label {
                    text: "📋 " + root.loadedSheets.length + " cheatsheets chargés"
                    opacity: 0.7
                }
                
                Item { Layout.fillWidth: true }
                
                PlasmaComponents.Label {
                    text: "Clic-milieu sur l'icône pour recharger | Cliquez sur les sections pour les replier/déplier"
                    opacity: 0.5
                    font.pixelSize: 10
                }
            }
        }
    }
    
    // ============== FONCTIONS ==============
    
    function showSheetContent(sheet) {
        console.log("📄 Affichage de:", sheet.name);
        
        // Mettre à jour le nom affiché
        root.currentSheetName = sheet.name;
        
        // Vider le modèle et réinitialiser les sections
        root.contentModel.clear();
        root.expandedSections = {};
        
        if (!sheet.sections) {
            console.log("❌ Pas de sections dans", sheet.name);
            return;
        }
        
        // Parcourir toutes les sections et items
        let allSections = Object.keys(sheet.sections);
        console.log("📊 Sections trouvées:", allSections);
        
        for (let i = 0; i < allSections.length; i++) {
            let sectionName = allSections[i];
            let section = sheet.sections[sectionName];
            let items = Object.keys(section);
            
            console.log("  📂 Section:", sectionName, "avec", items.length, "items");
            
            // Initialiser la section comme fermée par défaut
            root.expandedSections[sectionName] = false;
            
            // Ajouter l'en-tête de section
            root.contentModel.append({
                isSection: true,
                sectionName: sectionName,
                itemCount: items.length,
                itemName: "",
                description: "",
                code: ""
            });
            
            // Ajouter tous les items de la section
            for (let j = 0; j < items.length; j++) {
                let itemName = items[j];
                let item = section[itemName];
                
                root.contentModel.append({
                    isSection: false,
                    sectionName: sectionName,
                    itemCount: 0,
                    itemName: itemName,
                    description: item.description || "",
                    code: item.code || ""
                });
            }
        }
        
        console.log("✅ Total entrées ajoutées:", root.contentModel.count);
    }
    
    function toggleSection(sectionName) {
        root.expandedSections[sectionName] = !root.expandedSections[sectionName];
        root.expandedSectionsChanged();
    }
    
    function isSectionExpanded(sectionName) {
        return root.expandedSections[sectionName] === true;
    }
    
    function loadCheatsheets() {
        console.log("🔄 Rechargement des cheatsheets...");
        loadedSheets = [];
        
        let folders = [
            "Bootstrap", "CSS", "Docker", "Git", "HTML5", 
            "HTTP Status Codes", "JS", "Markdown", "Regex", 
            "Shell", "SQL", "Tmux", "Vim"
        ];
        
        folders.forEach(function(folderName) {
            let folderPath = cheatsheetFolder + "/" + folderName;
            let sheetData = loadSheetFromFolder(folderPath);
            if (sheetData) {
                loadedSheets.push(sheetData);
            }
        });
        
        console.log("✅ Chargé:", loadedSheets.length, "cheatsheets");
        loadedSheetsChanged();
    }
    
    function loadSheetFromFolder(folderPath) {
        try {
            let sheetJsonPath = folderPath + "/sheet.json";
            let iconPath = folderPath + "/icon.svg";
            
            let xhr = new XMLHttpRequest();
            xhr.open("GET", "file://" + sheetJsonPath, false);
            xhr.send();
            
            if (xhr.status === 200 || xhr.status === 0) {
                let sheetData = JSON.parse(xhr.responseText);
                sheetData.iconPath = iconPath;
                sheetData.folderPath = folderPath;
                console.log("📁 Chargé:", sheetData.name, "avec icône:", iconPath);
                return sheetData;
            }
        } catch (e) {
            console.log("❌ Erreur chargement:", folderPath, e.toString());
        }
        return null;
    }
    
    function copyToClipboard(text) {
        console.log("📋 Copie vers presse-papiers");
        
        // Méthode principale pour Plasma 6
        try {
            if (typeof Clipboard !== 'undefined') {
                Clipboard.copyText(text);
                console.log("✅ Copie réussie via Clipboard global");
                return true;
            }
        } catch (e) {
            console.log("⚠️ Clipboard global non disponible");
        }
        
        // Méthode alternative via Qt.application
        try {
            if (typeof Qt.application !== 'undefined' && Qt.application.clipboard) {
                Qt.application.clipboard.clear();
                Qt.application.clipboard.text = text;
                console.log("✅ Copie réussie via Qt.application.clipboard");
                return true;
            }
        } catch (e) {
            console.log("⚠️ Qt.application.clipboard non disponible");
        }
        
        // Méthode via un composant temporaire
        try {
            let clipboard = Qt.createQmlObject(`
                import QtQuick
                TextEdit {
                    id: clipboardHelper
                    visible: false
                    function copyText(txt) {
                        text = txt;
                        selectAll();
                        copy();
                    }
                }
            `, root, "clipboard");
            clipboard.copyText(text);
            clipboard.destroy();
            console.log("✅ Copie réussie via TextEdit");
            return true;
        } catch (e) {
            console.log("❌ Impossible de copier:", e.toString());
        }
        
        return false;
    }
}
