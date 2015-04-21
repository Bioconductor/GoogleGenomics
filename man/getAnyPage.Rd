\name{getAnyPage}
\alias{getAnyPage}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get a result page via Google Genomics API.
}
\description{Hack of getSearchPage to envoke any GG API method.  Might work with other Google API methods. Be sure to set right scopes in authenticate() command

}
\usage{
getAnyPage(entityType, body, fields, pageToken, json1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{entityType}{API method
}
  \item{body}{The body of the message to POST to the search endpoint. The massge con be provided either via 'body' or 'json1' arguments
}
  \item{fields}{The fields to be returned in the search response.
}
  \item{pageToken}{
The page token. This can be NULL for the first page.
}
  \item{json1}{The body of the message to POST in JSON.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
# authenticate with apropriate scope
authenticate(file='client_secrets.json',scope=c("https://www.googleapis.com/auth/genomics","https://www.googleapis.com/auth/devstorage.read_write"))

#fetch ReadGroupSets for a dataSetId
rgs1=getAnyPage("readgroupsets/search",body = list(datasetIds=list('10473108253681171589')),fields = NULL,pageToken = NULL)# 1000 Genomes Project dataset

#make table of readGroupSets id,name,filename
rgs1.df=as.data.frame(t(sapply(rgs1$readGroupSets, function(x) unlist(x[c('id','name','filename')]))));rownames(rgs1.df)=rgs1.df[,'id'] 
head(rgs1.df,2)
#get alignments for the first 3 ReadGroupSes
alignments.ls=lapply(splitchar(rgs1.df$id[1:3]),function(sid1){
  reads <- getReads(readGroupSetId=sid1,
                    chromosome="9",
                    start=27573440,
                    end=27573619) 
  ## Fetching reads page
  readsToGAlignments(reads)
})

#plot alignments on one page
require(ggplot2)
require(ggbio)

do.call('tracks',lapply(alignments.ls,function(alignments) {autoplot(alignments, aes(color=strand, fill=strand)) +guides(colour=FALSE,fill=FALSE)}))





}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
