## MGIZA

According to Moses SMT, "MGIZA was developed by Qin Gao. It is an implementation of the popular GIZA++ word alignment toolkit to run multi-threaded on multi-core machines." The website referenced is now defunct, so don't hold your breath for updates. 

I have also included the Python NLTK library on this, as I will try to do on all the machines. 

## Quickstart

`vagrant ssh`
`cd ./tools`
`./getcorpora.sh && tokenize.sh`
Wait. A long time. 

## Using the MGIZA vagrant machine

From the root of the git repository, `cd ./mgiza && vagrant up` will get it going. Go get a cup of coffee while MGIZA compiles. After a few minutes, the machine will be up and ready for you to work. Get in by using `vagrant ssh`. You'll notice several sub-directories in the vagrant user's home. 

```
vagrant@vagrant-ubuntu-trusty-64:~$ ll
total 32
drwxr-xr-x 5 vagrant vagrant 4096 Nov 23 15:29 ./
drwxr-xr-x 4 root    root    4096 Nov 23 15:29 ../
-rw-r--r-- 1 vagrant vagrant  220 Apr  9  2014 .bash_logout
-rw-r--r-- 1 vagrant vagrant 3637 Apr  9  2014 .bashrc
drwx------ 2 vagrant vagrant 4096 Nov 23 15:29 .cache/
-rw-r--r-- 1 vagrant vagrant  675 Apr  9  2014 .profile
drwx------ 2 vagrant vagrant 4096 Nov 23 15:29 .ssh/
drwxr-xr-x 4 vagrant vagrant 4096 Nov 23 15:33 tools/
```

The "tools" directory is the one you'll want to do your work out of. Note: At no time is `sudo` necessary to use these tools. 

Looking inside the tools/ directory, here is what we find: 
```
vagrant@vagrant-ubuntu-trusty-64:~/tools$ ll
total 28
drwxr-xr-x 4 vagrant vagrant 4096 Nov 23 15:33 ./
drwxr-xr-x 5 vagrant vagrant 4096 Nov 23 15:29 ../
drwxr-xr-x 3 root    root    4096 Nov 23 15:33 bin/
drwxr-xr-x 3  353500   10000 4096 Jul 25  2008 europarl/
-rwxrwxr-x 1 vagrant vagrant  192 Nov 23 15:29 getcorpora.sh*
-rw-rw-r-- 1 vagrant vagrant 1649 Nov 23 15:29 mgiza_configfile
-rwxrwxr-x 1 vagrant vagrant  913 Nov 23 15:29 tokenize.sh*
```

`getcorpora.sh` will fetch the Europarl English-German parallel text and `tokenize.sh` will tokenize, transform, and run a mgiza's text classification on it. That part takes a while, so be patient. Also, a while means, "I let it run for six hours on 1024MB of memory and a single core and it didn't finish."

If you're curious as to how they're doing it, crack open the scripts and take a look. I won't tell anyone. `tokenize.sh` is mostly based on the work from [this blog](https://fabioticconi.wordpress.com/2011/01/17/how-to-do-a-word-alignment-with-giza-or-mgiza-from-parallel-corpus/). 