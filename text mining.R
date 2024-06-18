library(readxl)
#import data
transaksi <- read_excel("D:/MNZ/Data Analyst/PROJECT/7. Text Mining/data transaksi teller dan cs.xlsx")
View(transaksi)
head(transaksi,10)

#define variabel
cs <- transaksi$`Rata-Rata Transaksi CS`
teller <- transaksi$`Rata-Rata Transaksi per Teller`
word.cs <- transaksi$`Jenis Transaksi Dominan CS`
word.teller <- transaksi$`Jenis Transaksi Dominan Teller`
waktu.cs <- transaksi$`Nasabah CS Terakhir dilayani`
waktu.teller <- transaksi$`Nasabah Teller terakhir dilayani`

#korelasi waktu vs rata-rata transaksi
library(lattice)
xyplot(cs ~ waktu.cs, data = transaksi,
       xlab = "Waktu Nasabah CS Terakhir Dilayani", 
       ylab = "Rata-rata Transaksi per CS", 
       main = "Hubungan antara Waktu Nasabah CS Terakhir Dilayani dengan Rata-rata Transaksi per CS")
cor(cs, waktu.cs, method = "pearson")

#word cloud
library(tm)
library(tidytext)
library(textclean)
library(devtools)
#install_github("nurandi/katadasaR")
library(katadasaR)
library(tokenizers)
library(stopwords)
library(lifecycle)
library(wordcloud)

#data preparation
head(word.cs, n=10)

#convert to lower
word.cs <- tolower(word.cs)
head(word.cs, n=10)

#delete semua simbol yang tidak relevan seperti tanda koma
word.cs[17]
word.cs <- strip(word.cs)
word.cs[17]

#mengubah menjadi kata dasar (stemming)
word.cs[6]
stemming <- function(x){
  paste(lapply(x,katadasar),collapse = " ")}
word.cs <- lapply(tokenize_words(word.cs[]), stemming)
word.cs[6]

#mengubah kalimat menjadi per kata
word.cs <- tokenize_words(word.cs)
head(word.cs)

#membuang kata hubung
myStopwords <- read.table("D:/MNZ/Data Analyst/PROJECT/7. Text Mining/stopword_list_id.txt")
word.cs <- as.character(word.cs)
word.cs <- tokenize_words(word.cs, stopwords = myStopwords)
head(word.cs, 3)

#membuat wordcloud
class(word.cs)
word.cs <- as.character(word.cs)
wordcloud(words = word.cs,
          random.order = F,
          max.words = 1000,
          colors = brewer.pal(name="Dark2",8))


#teller
#hubungan dua variabel
library(lattice)
xyplot(teller ~ waktu.teller, data = transaksi,
       xlab = "Nasabah Teller Terakhir Dilayani", 
       ylab = "Rata-rata Transaksi per Teller", 
       main = "Hubungan antara Nasabah Teller Terakhir Dilayani dengan Rata-rata Transaksi per Teller")
cor(teller, waktu.teller, method = "pearson")

#word cloud
library(tidytext)
library(textclean)
library(devtools)
library(katadasaR)
library(tokenizers)
library(stopwords)
library(lifecycle)
library(wordcloud)

head(word.teller, n=10)
#merubah data text menjadi huruf kecil semua
word.teller <- str_to_lower(word.teller)
head(word.teller, n=10)
#menghapus semua simbol yang tidak relevan seperti tanda koma
word.teller[4]
word.teller <- strip(word.teller)
word.teller[4]
#mengubah menjadi kata dasar (stemming)
word.teller[9]
stemming <- function(x){
  paste(lapply(x,katadasar),collapse = " ")}
word.teller <- lapply(tokenize_words(word.teller[]), stemming)
word.teller[9]
#mengubah kalimat menjadi per kata
word.teller <- tokenize_words(word.teller)
head(word.teller)
#membuang kata hubung
word.teller[3]
myStopwords <- read.table("D:/MNZ/Data Analyst/PROJECT/7. Text Mining/stopword_list_id.txt")
word.teller <- as.character(word.teller)
word.teller <- tokenize_words(word.teller, stopwords = myStopwords)
word.teller[3]
#membuat wordcloud
class(word.teller)
word.teller <- as.character(word.teller)
wordcloud(words = word.teller,
          random.order = F,
          colors = brewer.pal(name="Dark2",8))

