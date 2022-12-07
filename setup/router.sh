echo "This script is used to setup the server. It will: "
echo "  1. Downlaod NYU-METS dataset and extract them to ~/NYU-METS-Dataset"
echo "  2. Downlaod three traffic control scripts to ~/"
echo "Enter y to continue, any other key to exit: "
read input
if [ "$input" != "Y" ] && [ "$input" != "y" ]; then
echo "Exiting"
exit
fi

echo "Downlaoding and Extracting NYU-METS dataset"
wget https://github.com/Souukou/bu_cs655_adaptive_video_analyzing/raw/main/files/NYU-METS-Dataset.tar.gz -O /tmp/NYU-METS-Dataset.tar.gz
tar -xzf /tmp/NYU-METS-Dataset.tar.gz -C ~/ && rm -f /tmp/NYU-METS-Dataset.tar.gz

echo "Downlaoding and Extracting NYU-METS dataset"
wget https://github.com/Souukou/bu_cs655_adaptive_video_analyzing/raw/main/files/rate-set.sh -O ~/rate-set.sh
wget https://github.com/Souukou/bu_cs655_adaptive_video_analyzing/raw/main/files/rate-interrupt.sh -O ~/rate-interrupt.sh
wget https://github.com/Souukou/bu_cs655_adaptive_video_analyzing/raw/main/files/rate-vary.sh -O ~/rate-vary.sh

echo "Done"
