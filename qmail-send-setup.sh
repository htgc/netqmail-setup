#!/bin/sh

# check for /var/qmail is exist
# if not, execute ./netqmail-setup.sh
if ! [ -d /var/qmail ]; then
    exec ./netqmail-setup.sh
fi

if [ -d /var/qmail-send ]; then
    echo "/var/qmail-send exists"
    exit 1
fi
mkdir /var/qmail-send
chmod +t /var/qmail-send

cat >/var/qmail-send/run <<'__EOD__'
#!/bin/sh

exec env - PATH=$PATH:/var/qmail/bin \
qmail-start ./Maildir
__EOD__
chmod +x /var/qmail-send/run

mkdir -p /var/qmail-send/log/main
cat >/var/qmail-send/log/run <<'__EOD__'
#!/bin/sh

exec env - PTAH=$PATH:/var/qmail/bin \
setuidgid qmaill\
multilog t ./main -'*' +'* status: *' =status
__EOD__
chmod +x /var/qmail-send/log/run
chown -R qmaill:nofiles /var/qmail-send/log

ln -s /var/qmail-send /service/

echo "setup complete"
exit 0
