#!/bin/bash
sudo apt update -y
sudo apt install -y nodejs npm

mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

cat <<EOF > server.js
const express = require('express');
const path = require('path');
const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.get("/", (req, res) => {
  res.send(\`<form id="form">
      <input name="id" placeholder="ID" />
      <input name="name" placeholder="Name" />
      <button type="submit">Submit</button>
    </form>
    <script>
      document.getElementById('form').addEventListener('submit', async (e) => {
        e.preventDefault();
        const data = {
          id: e.target.id.value,
          name: e.target.name.value
        };
        const res = await fetch('http://${backend_ip}:5000/submit', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data)
        });
        const result = await res.json();
        alert(result.message);
      });
    </script>
  \`);
});

app.listen(3000, '0.0.0.0', () => {
  console.log("Frontend running on port 3000");
});
EOF

npm init -y
npm install express

nohup node server.js > frontend.log 2>&1 &
