echo "This script is used to setup the server. It will: "
echo "  1. Install apache2" 
echo "  2. Downlaod sample videos and extract them to /var/www/html" 
echo "It takes more than 10 minutes to complete."
echo "Enter y to continue, any other key to exit: "
read input
if [ "$input" != "Y" ] && [ "$input" != "y" ]; then
echo "Exiting"
exit
fi

echo "Installing apache"
sudo apt update
sudo apt install -y apache2

echo "Downloading sample videos"
wget https://nyu.box.com/shared/static/d6btpwf5lqmkqh53b52ynhmfthh2qtby.tgz -O /tmp/media.tgz

echo "Extracting file and cleaning up"
sudo tar -xzf /tmp/media.tgz -C /var/www/html/ && rm -f /tmp/media.tgz

echo "Done"
