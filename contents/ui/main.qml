// Cheaty KDE - Version ultra-simple qui marche
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
    
    preferredRepresentation: compactRepresentation
    toolTipMainText: "Cheaty KDE"
    toolTipSubText: loadedSheets.length + " cheatsheets disponibles"
    
    Component.onCompleted: {
        console.log("🚀 Cheaty KDE ultra-simple");
        loadCheatsheets();
    }
    
    // ============== ICÔNE DANS LA BARRE ==============
    compactRepresentation: MouseArea {
        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        
        hoverEnabled: true
        
        Kirigami.Icon {
            anchors.fill: parent
            source: "accessories-text-editor"
            active: parent.containsMouse
            scale: parent.containsMouse ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 150 } }
        }
        
        onClicked: {
            if (loadedSheets.length > 0) {
                console.log("📋 Ouverture menu");
                mainMenu.popup();
            } else {
                root.expanded = true;
            }
        }
        
        // ============== MENU PRINCIPAL ==============
        Menu {
            id: mainMenu
            
            // Propriétés de taille pour Plasma 6
            width: 250
            
            MenuItem {
                text: "📋 Cheatsheets (" + loadedSheets.length + ")"
                enabled: false
                height: 30  // Hauteur fixe
            }
            
            MenuSeparator {}
            
            // Bootstrap
            MenuItem {
                text: "🅱️ Bootstrap"
                height: 35
                visible: hasSheet("Bootstrap")
                onTriggered: showSections("Bootstrap")
            }
            
            MenuItem {
                text: "🎨 CSS"
                height: 35
                visible: hasSheet("CSS")
                onTriggered: showSections("CSS")
            }
            
            MenuItem {
                text: "🐳 Docker"
                height: 35
                visible: hasSheet("Docker")
                onTriggered: showSections("Docker")
            }
            
            MenuItem {
                text: "📂 Git"
                height: 35
                visible: hasSheet("Git")
                onTriggered: showSections("Git")
            }
            
            MenuItem {
                text: "🌐 HTML5"
                height: 35
                visible: hasSheet("HTML5")
                onTriggered: showSections("HTML5")
            }
            
            MenuItem {
                text: "📡 HTTP Status Codes"
                height: 35
                visible: hasSheet("HTTP Status Codes")
                onTriggered: showSections("HTTP Status Codes")
            }
            
            MenuItem {
                text: "⚡ JavaScript"
                height: 35
                visible: hasSheet("JS")
                onTriggered: showSections("JS")
            }
            
            MenuItem {
                text: "📝 Markdown"
                height: 35
                visible: hasSheet("Markdown")
                onTriggered: showSections("Markdown")
            }
            
            MenuItem {
                text: "🔍 Regex"
                height: 35
                visible: hasSheet("Regex")
                onTriggered: showSections("Regex")
            }
            
            MenuItem {
                text: "🐚 Shell"
                height: 35
                visible: hasSheet("Shell")
                onTriggered: showSections("Shell")
            }
            
            MenuItem {
                text: "🗄️ SQL"
                height: 35
                visible: hasSheet("SQL")
                onTriggered: showSections("SQL")
            }
            
            MenuItem {
                text: "📺 Tmux"
                height: 35
                visible: hasSheet("Tmux")
                onTriggered: showSections("Tmux")
            }
            
            MenuItem {
                text: "✏️ Vim"
                height: 35
                visible: hasSheet("Vim")
                onTriggered: showSections("Vim")
            }
            
            MenuSeparator {}
            
            MenuItem {
                text: "🔄 Recharger"
                onTriggered: loadCheatsheets()
            }
            
            MenuItem {
                text: "⚙️ Configuration"
                onTriggered: root.expanded = true
            }
        }
        
        // ============== MENU SECTIONS ==============
        Menu {
            id: sectionsMenu
            title: "Sections"
            width: 280
            
            MenuItem {
                id: sectionsTitle
                text: "📂 Sections"
                enabled: false
                height: 30
            }
            
            MenuSeparator {}
            
            // Les sections seront ajoutées dynamiquement
            
            MenuSeparator {}
            
            MenuItem {
                text: "⬅️ Retour"
                onTriggered: mainMenu.popup()
            }
        }
        
        // ============== MENU ITEMS ==============
        Menu {
            id: itemsMenu
            title: "Items"
            width: 300
            
            MenuItem {
                id: itemsTitle
                text: "💡 Items"
                enabled: false
                height: 30
            }
            
            MenuSeparator {}
            
            // Les items seront ajoutés dynamiquement
            
            MenuSeparator {}
            
            MenuItem {
                text: "⬅️ Retour aux sections"
                onTriggered: sectionsMenu.popup()
            }
        }
    }
    
    // ============== INTERFACE ÉTENDUE ==============
    fullRepresentation: Item {
        Layout.minimumWidth: 400
        Layout.minimumHeight: 300
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15
            
            Kirigami.Heading {
                text: "🎯 Cheaty KDE"
                level: 1
                Layout.alignment: Qt.AlignHCenter
            }
            
            PlasmaComponents.Label {
                text: "Navigation simple : Cheatsheets → Sections → Items → Code copié !"
                Layout.alignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Kirigami.Theme.textColor
                opacity: 0.2
            }
            
            RowLayout {
                PlasmaComponents.Label {
                    text: "📋 Cheatsheets détectés :"
                    font.bold: true
                }
                PlasmaComponents.Label {
                    text: loadedSheets.length
                    color: Kirigami.Theme.positiveTextColor
                    font.bold: true
                }
            }
            
            PlasmaComponents.Button {
                text: "🔄 Recharger cheatsheets"
                Layout.alignment: Qt.AlignHCenter
                onClicked: loadCheatsheets()
            }
            
            PlasmaComponents.Button {
                text: "🧪 Tester menu"
                Layout.alignment: Qt.AlignHCenter
                onClicked: mainMenu.popup()
            }
            
            // Liste simple des cheatsheets
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                ListView {
                    model: loadedSheets
                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 40
                        color: "transparent"
                        border.color: Kirigami.Theme.textColor
                        border.width: 1
                        opacity: 0.1
                        radius: 5
                        
                        RowLayout {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 10
                            
                            Kirigami.Icon {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                source: modelData.iconPath ? "file://" + modelData.iconPath : "text-x-generic"
                            }
                            
                            PlasmaComponents.Label {
                                text: modelData.name
                                font.bold: true
                            }
                        }
                    }
                }
            }
        }
    }
    
    // ============== FONCTIONS ==============
    
    function hasSheet(sheetName) {
        for (let i = 0; i < loadedSheets.length; i++) {
            if (loadedSheets[i].name.includes(sheetName) || 
                loadedSheets[i].folderPath.includes(sheetName)) {
                return true;
            }
        }
        return false;
    }
    
    function getSheet(sheetName) {
        for (let i = 0; i < loadedSheets.length; i++) {
            if (loadedSheets[i].name.includes(sheetName) || 
                loadedSheets[i].folderPath.includes(sheetName)) {
                return loadedSheets[i];
            }
        }
        return null;
    }
    
    function showSections(sheetName) {
        console.log("📂 DEBUT showSections pour:", sheetName);
        let sheet = getSheet(sheetName);
        console.log("📄 Sheet trouvé:", sheet ? sheet.name : "NULL");
        
        if (!sheet) {
            console.log("❌ Pas de sheet trouvé pour", sheetName);
            return;
        }
        
        if (!sheet.sections) {
            console.log("❌ Pas de sections dans", sheet.name);
            console.log("📋 Contenu sheet:", Object.keys(sheet));
            return;
        }
        
        console.log("📂 Sections disponibles:", Object.keys(sheet.sections));
        
        currentSheet = sheet;
        
        // FIX: Accès correct à sectionsTitle
        if (sectionsMenu.itemAt(0)) {
            sectionsMenu.itemAt(0).text = "📂 " + sheet.name;
        }
        
        // Supprimer TOUS les items sauf les 3 premiers (titre, séparateur, séparateur final) et le dernier (retour)
        let itemsToRemove = [];
        for (let i = 2; i < sectionsMenu.count - 2; i++) {
            let item = sectionsMenu.itemAt(i);
            if (item) {
                itemsToRemove.push(item);
            }
        }
        
        console.log("🗑️ Suppression de", itemsToRemove.length, "anciens items");
        itemsToRemove.forEach(item => {
            try {
                sectionsMenu.removeItem(item);
            } catch (e) {
                console.log("❌ Erreur suppression item:", e.toString());
            }
        });
        
        // Ajouter les nouvelles sections à l'index 2 (après titre et séparateur)
        let insertIndex = 2;
        let sectionsAdded = 0;
        
        for (let sectionName in sheet.sections) {
            console.log("➕ Ajout section:", sectionName);
            try {
                let sectionItem = Qt.createQmlObject(`
                    import QtQuick.Controls
                    MenuItem {
                        text: "📝 ${sectionName}"
                        height: 35
                        onTriggered: {
                            console.log("🎯 Section cliquée:", "${sectionName}");
                            root.showItems("${sectionName}");
                        }
                    }
                `, root, "section-" + sectionName.replace(/\s+/g, '_'));
                
                sectionsMenu.insertItem(insertIndex++, sectionItem);
                sectionsAdded++;
                console.log("✅ Section ajoutée:", sectionName);
            } catch (e) {
                console.log("❌ Erreur création section:", sectionName, e.toString());
            }
        }
        
        console.log("📊 Total sections ajoutées:", sectionsAdded);
        console.log("📋 Menu sections count:", sectionsMenu.count);
        
        sectionsMenu.popup();
        console.log("📂 FIN showSections");
    }
    
    function showItems(sectionName) {
        console.log("💡 Affichage items pour:", sectionName);
        if (!currentSheet || !currentSheet.sections[sectionName]) {
            console.log("❌ Section introuvable:", sectionName);
            return;
        }
        
        currentSection = sectionName;
        
        // FIX: Accès correct au titre
        if (itemsMenu.itemAt(0)) {
            itemsMenu.itemAt(0).text = "💡 " + sectionName;
        }
        
        let sectionData = currentSheet.sections[sectionName];
        
        // Supprimer les anciens items de façon plus sûre
        let itemsToRemove = [];
        for (let i = 2; i < itemsMenu.count - 2; i++) {
            let item = itemsMenu.itemAt(i);
            if (item) {
                itemsToRemove.push(item);
            }
        }
        
        console.log("🗑️ Suppression de", itemsToRemove.length, "anciens items");
        itemsToRemove.forEach(item => {
            try {
                itemsMenu.removeItem(item);
            } catch (e) {
                console.log("❌ Erreur suppression item:", e.toString());
            }
        });
        
        // Ajouter les nouveaux items
        let insertIndex = 2;
        for (let itemName in sectionData) {
            let itemData = sectionData[itemName];
            let code = itemData.code || "";
            let safeName = itemName.replace(/"/g, '\\"');
            
            try {
                let menuItem = Qt.createQmlObject(`
                    import QtQuick.Controls
                    MenuItem {
                        property string itemCode: \`${code.replace(/`/g, '\\`').replace(/\$/g, '\\
    
    function loadCheatsheets() {
        console.log("🔄 Rechargement...");
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
                return sheetData;
            }
        } catch (e) {
            console.log("❌ Erreur:", folderPath, e.toString());
        }
        return null;
    }
    
    function copyToClipboard(text) {
        console.log("📋 Copie vers presse-papiers:", text.substring(0, 50) + "...");
        
        if (typeof Qt.application !== 'undefined' && Qt.application.clipboard) {
            Qt.application.clipboard.text = text;
            console.log("✅ Copie réussie via Qt.application.clipboard");
            return true;
        }
        
        console.log("❌ Qt.application.clipboard non disponible");
        return false;
    }
})}\`
                        text: "🎯 ${safeName}"
                        height: 35
                        onTriggered: {
                            console.log("✅ Code copié:", "${safeName}");
                            root.copyToClipboard(itemCode);
                        }
                    }
                `, root, "item-" + itemName.replace(/\s+/g, '_'));
                
                itemsMenu.insertItem(insertIndex++, menuItem);
            } catch (e) {
                console.log("❌ Erreur création item:", itemName, e.toString());
            }
        }
        
        itemsMenu.popup();
    }
    
    function loadCheatsheets() {
        console.log("🔄 Rechargement...");
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
                return sheetData;
            }
        } catch (e) {
            console.log("❌ Erreur:", folderPath, e.toString());
        }
        return null;
    }
    
    function copyToClipboard(text) {
        console.log("📋 Copie vers presse-papiers:", text.substring(0, 50) + "...");
        
        if (typeof Qt.application !== 'undefined' && Qt.application.clipboard) {
            Qt.application.clipboard.text = text;
            console.log("✅ Copie réussie via Qt.application.clipboard");
            return true;
        }
        
        console.log("❌ Qt.application.clipboard non disponible");
        return false;
    }
}