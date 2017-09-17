// This file contains your Data Connector logic
section PQBoxExtension;

[DataSource.Kind="PQBoxExtension", Publish="PQBoxExtension.Publish"]
shared PQBoxExtension.Contents = (optional message as text) =>
    let
        _message = if (message <> null) then message else "(no message)",
        a = "Hello from PQBoxExtension: " & _message
    in
        a;

// Data Source Kind description
PQBoxExtension = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
PQBoxExtension.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PQBoxExtension.Icons,
    SourceTypeImage = PQBoxExtension.Icons
];

PQBoxExtension.Icons = [
    Icon16 = { Extension.Contents("PQBoxExtension16.png"), Extension.Contents("PQBoxExtension20.png"), Extension.Contents("PQBoxExtension24.png"), Extension.Contents("PQBoxExtension32.png") },
    Icon32 = { Extension.Contents("PQBoxExtension32.png"), Extension.Contents("PQBoxExtension40.png"), Extension.Contents("PQBoxExtension48.png"), Extension.Contents("PQBoxExtension64.png") }
];
