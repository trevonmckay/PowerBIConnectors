// This file contains your Data Connector logic
section PQBoxAdminExtension;

[DataSource.Kind="PQBoxAdminExtension", Publish="PQBoxAdminExtension.Publish"]
shared PQBoxAdminExtension.Feed = Value.ReplaceType(PQBoxAdminExtensionImpl, type function(url as Uri.Type) as any);

PQBoxAdminExtensionImpl = (url as text) =>
    let
        source = OData.Feed(url)
    in
        source;

shared PQBoxAdminExtension.Contents = (optional message as text) =>
    let
        _message = if (message <> null) then message else "(no message)",
        a = "Hello from PQBoxAdminExtension: " & _message
    in
        a;

// Data Source Kind description
PQBoxAdminExtension = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
PQBoxAdminExtension.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PQBoxAdminExtension.Icons,
    SourceTypeImage = PQBoxAdminExtension.Icons
];

PQBoxAdminExtension.Icons = [
    Icon16 = { Extension.Contents("PQBoxAdminExtension16.png"), Extension.Contents("PQBoxAdminExtension20.png"), Extension.Contents("PQBoxAdminExtension24.png"), Extension.Contents("PQBoxAdminExtension32.png") },
    Icon32 = { Extension.Contents("PQBoxAdminExtension32.png"), Extension.Contents("PQBoxAdminExtension40.png"), Extension.Contents("PQBoxAdminExtension48.png"), Extension.Contents("PQBoxAdminExtension64.png") }
];
