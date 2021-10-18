# H1 What is WEb Detective?

Web detective is a small program written in Powershell, and it's purpose is to  
troubleshoot your Internet access. Trouble can originate in many ways, and  
Web Detective attempts to examine them all: the computer you are sitting at,
cable or wifi connection to your local router, your ISP's router, and so on.  

# H1 How do I use Web Detective?

In order to examine your connection to Internet, it's necessary to know where  
you live. You want to know that you can access computers in the city you live  
in, or your closest ciyt, before you try to reach places further away. Therefore  
it is necessary to tell Web Detective where you live. You can do this by selecting
the area where you live in the dropdown menues you can see on the left side of  
the Web Detective window. First you select the continent where you live, and when
you have made that selection, you can see a new dropdown menu whre you select  
the nation where you live, and so on. In a few steps, usually four to six, you
will have selected a nerby city.

When this is done, you will see a button, with the text "Run Basic Tests". When you  
push this button, the computer will automatically perform a series of tests and  
write the result in the text box.  

If Web Detective says that "You appear to have basic access to Internet, you can  
know that you at least can access nerby computers. Any remaining troubles have  
to be further away.

This is as far as the initial version of Web Detective goes. Long distance tests
are planned, but this reqire a combrehensive database for Internet access,
and this is the next main task.  

# H1 How is the database designed?

The database is very simple. In the subdirectory "database" you find one subdirectory  
for every continent. For every continent you find a directory per nation, and so on.  
Some nations can appear in two continents. As an example: Russia has one part in
Europe, and another in Asia. Cities in the European part should then be listed
or created as directories in the European subree, and Asian cities in the Asian  
subtree. Adding information for a new city or region is done by adding new
directories to this structure.

The subdirectory with a city name should contain three files: location.txt, sites.txt,
and ISPs.txt. All files are csv files. (Comma separated values.)

Location.txt should contain the latitude and longitude for the city, expressed as  
degrees with a decimal part. The values should be presice to one minute of arc,
or better. This information can be used to create long distance tests.  

Sites.txt is a simple list of computers in the city, usable with the test program  
ping. They are used in the basic access testing.  

ISPs.txt contains the names of local ISPs, and a list of IP adresses to their
most local DNS servers. One per line. An example line would be:  
Bredband2,89.160.20.18,89.160.20.22 This is correct information for an ISP  
in Sweden, and for the city where Web Detective was developed. This information
is also used in the basic testing phase. This can easily be modified to allow
mulitple ISPs in a city, but again it has to wait for next version.  
