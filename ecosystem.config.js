module.exports = {
  apps : [{
    name   : "n8n",
    script : "n8n",
    env: {
      N8N_LISTEN_ADDRESS: "0.0.0.0",
      N8N_SECURE_COOKIE: "false",
      N8N_NODES_EXCLUDE: "[]",
      NODES_EXCLUDE: "[]",
      N8N_JS_MODULES_ALLOW_BUILTIN: "*",
      N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS: "false"
    }
  }]
}