import Data.Word
import Text.Printf (printf)
import System.IO (hFlush, stdout)
import System.Environment as Env

--import Language.HAsm.Types
import Language.HAsm.Parse
import Language.HAsm.PrettyPrint
import Language.HAsm.X86.Opcodes (bytecode)
import Language.HAsm.X86.CPU (Operation(..))
--import Language.HAsm.Codegen
--import Language.HAsm.X86.Opcodes

import Language.HAsm.Test

{-
 - main
 -}
hexBytecode :: [Word8] -> String
hexBytecode = concat . map (printf "%02x ")

mainOpToHex = do
    putStr "**HASM**> " >> hFlush stdout
    op <- readLn :: IO Operation
    putStrLn $ hexBytecode $ bytecode op
    mainOpToHex

mainParseAssemble = do
    putStr "*HASM*> " >> hFlush stdout
    ln <- getLine
    case hasmParseWithSource "stdin" (ln ++ "\n") of
      Left e -> putStrLn $ "Syntax ERROR\n" ++ show e
      Right pstmts -> do
        --print pstmts
        case assembleFromZero pstmts of
          Left e -> putStrLn $ "Codegen ERROR\n" ++ e
          Right res -> putPretty res
    mainParseAssemble

mainProcessFile fpath = do
    file <- readFile fpath
    case hasmParseWithSource file file of
      Left e -> putStrLn $ "Syntax ERROR\n" ++ show e
      Right pstmts -> do
        case assembleFromZero pstmts of
          Left e -> putStrLn $ "Codegen ERROR\n" ++ show e
          Right res -> putPretty res

main = do
    args <- Env.getArgs
    case args of
      [] ->
          mainParseAssemble
      [fpath] ->
          mainProcessFile fpath
      _ ->
          putStrLn "???"
