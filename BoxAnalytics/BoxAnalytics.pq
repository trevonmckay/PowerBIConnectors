// This file contains your Data Connector logic
section BoxAnalytics;

client_id = Text.FromBinary(Extension.Contents("client_id"));
client_secret = Text.FromBinary(Extension.Contents("client_secret"));
redirect_uri = "https://preview.powerbi.com/views/oauthredirect.html";
windowWidth = 1200;
windowHeight = 1000;

[DataSource.Kind="BoxAnalytics", Publish="BoxAnalytics.Publish"]
shared BoxAnalytics.Contents = Value.ReplaceType(BoxAnalyticsImpl, type function (url as Uri.Type) as any);

DefaultRequestHeaders = [
    #"Accept" = "application/json"
];

BoxAnalyticsImpl = (url as text) =>
    let
        content = Web.Contents(url, [ Headers = DefaultRequestHeaders ]),
        json = Json.Document(content)
        //table = Table.FromList(json, Splitter.SplitByNothing())
    in
        json;

// Data Source Kind description
BoxAnalytics = [
    Authentication = [
        OAuth = [
            StartLogin = StartLogin,
            FinishLogin = FinishLogin
        ]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

StartLogin = (resourceUrl, state, display) =>
    let
        AuthorizeUrl = "https://account.box.com/api/oauth2/authorize?" & Uri.BuildQueryString([
            client_id = client_id,
            redirect_uri = redirect_uri,
            response_type = "code",
            state = state])
    in
        [
            LoginUri = AuthorizeUrl,
            CallbackUri = redirect_uri,
            WindowHeight = windowHeight,
            WindowWidth = windowWidth,
            Context = null
        ];

FinishLogin = (context, callbackUri, state) =>
    let
        Parts = Uri.Parts(callbackUri)[Query]
    in
        TokenMethod(Parts[code]);

TokenMethod = (code) =>
    let
        Response = Web.Contents("https://api.box.com/oauth2/token", [
            Content = Text.ToBinary(Uri.BuildQueryString([
                client_id = client_id,
                client_secret = client_secret,
                code = code,
                grant_type = "authorization_code",
                redirect_uri = redirect_uri])),
            Headers = [#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

// Data Source UI publishing description
BoxAnalytics.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://docs.box.com/reference",
    SourceImage = BoxAnalytics.Icons,
    SourceTypeImage = BoxAnalytics.Icons
];

BoxAnalytics.Icons = [
    Icon16 = { Extension.Contents("BoxAnalytics16.png"), Extension.Contents("BoxAnalytics20.png"), Extension.Contents("BoxAnalytics24.png"), Extension.Contents("BoxAnalytics32.png") },
    Icon32 = { Extension.Contents("BoxAnalytics32.png"), Extension.Contents("BoxAnalytics40.png"), Extension.Contents("BoxAnalytics48.png"), Extension.Contents("BoxAnalytics64.png") }
];
