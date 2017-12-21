#' @include singscore.R CoreFuns.R
NULL

#'@title  Rank genes by the gene expression intensities
#'@description The \code{rankGenes} function is a generic function that can deal
#'  with mutilple types of inputs. Given a matrix of gene expression that has
#'  samples in columns, genes in rows, and values being gene expression
#'  intensity. \code{rankGenes} ranks gene expression in each sample. Given a
#'  gene expression matrix (i.e matrix, data.frame) or a S4 object that has gene
#'  expression matrix as a component (i.e ExpressionSet, DGEList) and a
#'  'tiesMethod', it calls the  \code{rank} function in the base package which
#'  ranks the gene expression matrix by its absolute expression level. If input
#'  is S4 object of \code{DGEList, or ExpressionSet}, the generic function will
#'  extract the gene epxression matrix genes on the rows and samples on columns
#'  from the object and rank the genes. The default ties.Method is set to 'min'
#'
#'@param expreMatrix A gene expression matrix or S4 object
#'  (matrix,data.frame,ExpressionSet,DGEList)
#'@param tiesMethod A character indicating what method to use when dealing with
#'  ties
#'@name rankGenes
#'
#'@return The ranked gene expression matrix that has samples in columns and
#'  genes in rows
#' @examples
#' rankGenes(toy_expr) # toy_expr is a gene expression matrix, tiesMethod = 'min'
#' e <- Biobase::ExpressionSet(assayData = as.matrix(toy_expr))
#' rankGenes(e) # or it can be a ExpressionSet object
#'@seealso \code{\link{rank}} [ExpressionSet][ExpressionSet-class]
#'[DGEList][DGEList-class]
#'
#'
#'@export
setGeneric("rankGenes",
           function(expreMatrix, 
                    tiesMethod = 'min') standardGeneric("rankGenes"))

#' @rdname rankGenes
setMethod("rankGenes", signature('matrix','ANY'), 
          function(expreMatrix,tiesMethod = 'min'){
            return(rankExpr(expreMatrix,tiesMethod = tiesMethod))
})

#' @rdname rankGenes
setMethod("rankGenes", 
          signature(expreMatrix = 'data.frame',
                    tiesMethod = 'ANY'), 
          function(expreMatrix, tiesMethod = 'min'){
  return(rankExpr(as.matrix(expreMatrix),tiesMethod = tiesMethod))
})

#' @rdname rankGenes
setMethod("rankGenes", 
          signature('DGEList',tiesMethod = 'ANY'), 
          function(expreMatrix,tiesMethod = 'min'){
            rankExpr(expreMatrix$counts,tiesMethod = tiesMethod)
})
#' @rdname rankGenes
setMethod("rankGenes", 
          signature('ExpressionSet',
                    tiesMethod = 'ANY'), 
          function(expreMatrix,tiesMethod = 'min'){
            rankExpr(Biobase::exprs(expreMatrix),tiesMethod = tiesMethod)
})