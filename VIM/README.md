VIM useful commmands
================
Aimer G. Diaz
9/27/2021

Vim as a text editor is highly editable or customizable and extensible,
meaning provides extensive support to various
[plugins](https://linuxhint.com/vim-vundle-tutorial/) in order to
enhance the Vim’s functionality. But one of its most important feature,
at least, for bioinformatic purpose is that Vim consume fewer system
resources than emacs, nano, or especially the graphical editors.
Additionally Vim is lightweight and very fast, even when modifying the
large numbers of files source code. Even more, you can run it over ssh
for various remote operations on any type of server.

1.  Useful setup of vim on \~/.vimrc

``` bash
# Setup for all the vim files of user show the enumeration per line
set number 
```

⋅⋅1. Delete a line or a specific set of lines

    #### A line which number is known 
    d #  

    dd 

⋅⋅1. <!---
```{=latex}
\begin{lstlisting}

\item Move to a particular line
 \begin{lstlisting}[language=bash]
 : # 
 \end{lstlisting}
\item Undo , Redo  and repeat 
\begin{lstlisting}[language=bash]
u , U (undo all the changes),  ctrl +R , . 
\end{lstlisting}
\item Introduce several characters simultaneously 
\begin{lstlisting}[language=bash]
 Ctrl + V , Select lines,  shift + i, \t or # 
\end{lstlisting}
\item  Introduce commands from the vim panel to outside the script  
\begin{lstlisting}[language=bash]
! cat <some file> 
! ls -lh 
 \end{lstlisting}

execute codes but for the current open file  
\begin{lstlisting}[language=bash]
! perl %
! wc %
 \end{lstlisting}
\item  Pattern matching 
\begin{lstlisting}[language=bash]
%s/<pattern syntax like perl>/<replace by>/g(lobal)  or c(case by case) 
n follow
N previous 
\end{lstlisting}
\item  Save and quite, save
\begin{lstlisting}[language=bash]
w! (save independent of the vim mode - like read only mode) 
w save only in read and write mode
wq wirte and quit 
q!  quite without save 
\end{lstlisting}
\item  Insert x times a pattern 

In normal mode (no editing, no command) 
\begin{lstlisting}[language=bash]
x times <character or word> then insert and then escape 
50GACG

\end{lstlisting}
\item  Two or more  screens
\begin{lstlisting}[language=bash]
:sp (horizontal split) 
:sp ./ split the current directory as a file of directories
:vsp  (vertical split)

ctrl + w + down move forward  + up move backward
ctrl + w _ reduce the size of the current window
ctrl + shift + = increase
ctrl + w + r MOVE TO THE TOP THE CURRENT WINDOW
\end{lstlisting}

\item resize 
\begin{lstlisting}
:res number chance the height to "number" rows
:res +number increment "number" rows
:res -number  decrease "number" rows
:vertical resize The same for columns

\end{lstlisting}

\item word movement
\begin{lstlisting}[language=bash]
shift + 6 begining of the line
shift + 4 end of the line
b to go to beginning of current or previous word
w to go the beginning of next word
e to go to the end of current or next word
ge to go the end of the previous word
\end{lstlisting}
\item  paste without adding \# automatically
\begin{lstlisting}[language=bash]
:set  paste
\end{lstlisting}
\item  command history
\begin{lstlisting}[language=bash]
q:
\end{lstlisting}
\item  put line numbers
\begin{lstlisting}[language=bash]
:set number
:set nonumber
\end{lstlisting}
\item  Recording mode
\begin{lstlisting}[language=bash]
1. write 1
2. Activate recording mode  qa
3. esc and press yy, then p 3.
4. move to the second 1 and press ctrl + a
5. close recording mode with q
6. press 99 or any number (shit +2 ) and then a
\end{lstlisting}
Automatizing writing for mysql scripts \url{http://www.thegeekstuff.com/2009/01/vi-and-vim-macro-tutorial-how-to-record-and-play/}

\item  copy and paste
\begin{lstlisting}[language=bash]
single line y and then p
select several lines v, y and then p
\end{lstlisting}
\item  word  completion
\begin{lstlisting}[language=bash]
in insert mode + ctrl + n
\end{lstlisting}
\item  show function documentation
\begin{lstlisting}[language=bash]
in edit mode and mayus press k over the function
\end{lstlisting}
\item  Use the mouse for movement
\begin{lstlisting}[language=bash]
:set mouse=a
:set mouse=
\end{lstlisting}
\item Know current file
\begin{lstlisting}[language=bash]
:f
In normal mode: 
1 then Ctrl+G to get the full file path. 
2 then Ctrl+G to get the full file path and the buffer number you currently have open.
\end{lstlisting}
```
--->
