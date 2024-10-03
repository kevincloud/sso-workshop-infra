const path = require("path")
const CopyPlugin = require("copy-webpack-plugin")
const ZipPlugin = require("zip-webpack-plugin")

module.exports = {
    entry: "./src/index.ts",
    resolve: {
        extensions: [".ts", ".js"],
    },
    module: {
        rules: [
            {
                test: /\.ts?$/,
                use: "ts-loader",
                exclude: /node_modules/,
            },
        ],
    },
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "main.js",
        library: "main",
        libraryTarget: "commonjs2",
    },
    plugins: [
        // saml library uses template files that must be copied with handler.
        new CopyPlugin({
            patterns: [
                {
                    from: "../../node_modules/saml/lib/saml20.template",
                    to: path.resolve(__dirname, "dist")
                },
                {
                    from: "../../node_modules/saml/lib/saml11.template",
                    to: path.resolve(__dirname, "dist")
                }
          ]
        }),
        new ZipPlugin({}),
    ],
    target: "node",
    devtool: "source-map",
}
