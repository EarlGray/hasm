module Language.HAsm.ELF (
) where

import Data.Int
import Data.Char (ord)
import Data.Binary
import Data.Binary.Put

import Control.Monad (forM_)

import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL

eiNIdent = 16

type Elf32_Addr = Word32
type Elf32_Half = Word16
type Elf32_Off =  Word32
type Elf32_Sword = Int32
type Elf32_Word = Word32

data ElfClass =      ElfClassNone | ElfClass32 | ElfClass64 deriving Enum
data ElfEncoding =   ElfDataNone  | ElfDataLSB | ElfDataMSB deriving Enum
data ElfVersion = EVNone | EVCurrrent deriving Enum
data ElfType =    ETNone | ETRel | ETExec | ETDYN | ETCore deriving Enum
data ElfMachine = EMNone | EM_M32 | EMSparc | EM386 | EM68k | EM88k | EM860 | EM_MIPS deriving Enum

int :: (Integral a, Num b) => a -> b
int = fromIntegral

num :: (Enum e, Num i) => e -> i
num = int . fromEnum

elf_magic :: B.ByteString
elf_magic = B.pack $ take eiNIdent $ magic ++ repeat 0x00
  where magic = (0x7f : map (int . ord) "ELF") ++ [num ElfClass32, num ElfDataLSB, num EVCurrrent, 0]

putElfHeader = do
     putByteString elf_magic
  

putElf :: Put
putElf = do
    putElfHeader
    forM_ [num ETRel, num EM386] putWord16le
    forM_ [num EVCurrrent, entry, phoff, shoff, flags] putWord32le
    forM_ [ehsize, phentsize, phnum, shentsize, shnum, shstrndx] putWord16le
  where
    entry = 0; phoff = 0; shoff = 0; flags = 0; ehsize = 52
    phentsize = 0; phnum = 0; shentsize = 0; shnum = 0; shstrndx = 0

writeElfFile :: FilePath -> IO ()
writeElfFile fname = BL.writeFile fname $ runPut putElf
