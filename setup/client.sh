echo "This script is used to set up the server. It will: "
echo "  1. Install python2" 
echo "  2. Clone git repo AStream created by pari685"
echo "  3. Download the experiment script"
echo "Enter y to continue, any other key to exit: "
read input
if [ "$input" != "Y" ] && [ "$input" != "y" ]; then
echo "Exiting"
exit
fi

echo "Installing python2"
sudo apt update
sudo apt install -y python2

echo "Cloning AStream"
git clone https://github.com/pari685/AStream

echo "Download experiment script"
wget https://github.com/Souukou/bu_cs655_adaptive_video_analyzing/raw/main/files/exp_client.sh -O ~/exp_client.sh

echo "Done"
