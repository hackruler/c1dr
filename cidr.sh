# Finding all the open ports for each ip in CIDR
# Run httpx on all the ip's found with their respective ports.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cexit() {
    echo -e "${RED}[!] Script interrupted. Exiting...${NC}"
    exit "$1"
}

trap 'cexit 1' SIGINT;

default_ports="66,80,81,443,445,457,1080,1100,1241,1352,1433,1434,1521,1944,2301,3000,3128,3306,4000,4001,4002,4100,5000,5001,5432,5800,5801,5802,6346,6347,7001,7002,8080,8443,8888,30821" 

while getopts "l:p:" opt; do
    case $opt in
        l)
            input_file="$OPTARG"
            ;;
        p)
            custom_ports="$OPTARG"
            ;;
        \?)
            echo -e "${GREEN}Usage: bash $0 -l <input_file> [-p<ports>]${NC}"
            cexit 1
            ;;
    esac
done

if [ -z "$input_file" ]; then
    echo -e "${GREEN}Usage: bash $0 -l <input_file> [-p<ports>]${NC}"
    cexit 1
fi

if [ -z "$custom_ports" ]; then
    ports_option="-p$default_ports"
else
    ports_option="-p$custom_ports"
fi

if [ ! -f "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is not present in the directory.${NC}"
    cexit 1
fi

if [ ! -s "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is empty.${NC}"
    cexit 1
fi

if [ ! -r "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is not readable.${NC}"
    cexit 1
fi

echo -e "${YELLOW}[!] Finding open ports on all the IP's.${NC}"
sudo masscan -iL "$input_file" "$ports_option" --rate=10000000 | anew masscan.txt > /dev/null || cexit $?;
echo -e "${GREEN}[*] Result is stored to masscan.txt${NC}"
echo -e "${GREEN}[**]" $(cat masscan.txt | wc -l)" IP's found with open ports.${NC}"
cat masscan.txt | cut -d " " -f6 | sed 's/n//g' | sed 's/^ *\|\ *$//g' | sed 's/$/:/' | tee -a ip_add.txt > /dev/null || cexit $?;
cat masscan.txt | cut -d "/" -f1 | cut -d 't' -f2 | sed 's/^ *//g' | tee -a port.txt > /dev/null || cexit $?;

echo -e "${YELLOW}[!] httpx is running on all the IP's found with respective ports.${NC}"
paste ip_add.txt port.txt | sed 's/\t//g' | httpx -silent -sc -td -cl | tee -a httpx_ip.txt || cexit $?;

rm ip_add.txt port.txt masscan.txt;
echo -e "${GREEN}[*] httpx result is stored in httpx_ip.txt${NC}"
echo -e "${GREEN}[**]" $(cat httpx_ip.txt | wc -l)" IP's giving any response on the browser.${NC}";
echo "....................SCRIPT ENDED......................"
