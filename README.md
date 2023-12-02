# c1dr
Let's find all the working ip's in the CIDR range by finding their respective open ports.

# Installation
`git clone https://github.com/hackruler/c1dr.git`

`cd c1dr`

# Usage

`bash cidr.sh -l <path to cidr file> [options]`

#Example

![image](https://github.com/hackruler/c1dr/assets/82742964/bd00c750-820b-4f45-bd1f-77ac02204944)


# More effectively you can use this like...

After Installation

**Make an alias using this-**

Append this command in .zshrc file or .bashrc file

`alias cidr='bash <path to file>/c1dr/cidr.sh`

And then type this command to save...

`source ~/.bashrc` Or `source ~/.zshrc`

Then you can use this as...

`cidr -l <domain file path> [options]`

# Example

![image](https://github.com/hackruler/c1dr/assets/82742964/8d4047f3-fc93-476a-98da-8ef8787d6056)

