#!/data/data/com.termux/files/usr/bin/bash

clear
echo "=========================="
echo "      NAHID MODZ"
echo "     INSTALLER"
echo "=========================="

pkg install -y curl toilet coreutils

curl -fL \
"https://raw.githubusercontent.com/nahidmodz00/NAHID-MODZ/main/nahid.sh" \
-o "$HOME/nahid.sh" || {
    echo "Download failed!"
    exit 1
}

chmod +x "$HOME/nahid.sh"

mkdir -p "$PREFIX/bin"

cat > "$PREFIX/bin/nahid" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
bash "$HOME/nahid.sh"
EOF

chmod +x "$PREFIX/bin/nahid"

echo "NAHID MODZ INSTALLED!"
echo "Type nahid to launch."

bash "$HOME/nahid.sh"
