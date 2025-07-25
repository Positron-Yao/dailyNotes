module Main where
import System.Process
import System.Directory
import System.Environment
import Data.Time

main :: IO ()
main = do
  homeD <- getHomeDirectory
  pwd <- getEnv "DNDIARY"
  -- 设置工作目录
  setCurrentDirectory pwd
  -- putStrLn homeD
  -- putStrLn pwd
  -- 获取今天日期
  -- byd我用了半年了才发现忘了+8了草
  today <- getCurrentTime >>=  \t -> return $ utctDay $ addUTCTime (8*3600) t
  let todayStr = show today
  -- 分析命令行参数
  args <- getArgs 
  if not (null args) then do
    -- let arg = head args
    case args of
      [arg] -> do
        argCode <- case arg of
          "d"  -> return 0 :: IO Int
          "dir"  -> return 0 :: IO Int
          "h"  -> return 1 :: IO Int
          "help" -> return 1 :: IO Int
          "l"  -> return 2 :: IO Int
          "list" -> return 2 :: IO Int
          "g"  -> return 3 :: IO Int
          "glow" -> return 3 :: IO Int
          "m"  -> return 4 :: IO Int
          "main" -> return 4 :: IO Int
          "t"  -> return 5 :: IO Int
          "todo" -> return 5 :: IO Int
          "p"  -> return 6 :: IO Int
          "tmp"  -> return 6 :: IO Int
          _    -> return 1 :: IO Int

        case argCode of
          0 -> do 
            let fp = pwd ++ "diary/"
            _ <- system $ "echo " ++ fp ++ "| clip"
            putStrLn $ "\x1B[34m文件目录: " ++ fp ++  "\n\x1B[33m已复制到剪贴板~\x1B[0m"

          1 -> putStrLn "\n\x1B[34m# diaryNotes: 命令行快速笔记工具\n\
            \\x1B[33m打开每日对应的日记文件(.md)\n\
            \使用:\n\
            \  \x1B[33;2m-\x1B[0m\x1B[32m dn: 打开今日日记文件\n\
            \  \x1B[33;2m-\x1B[0m\x1B[32m dn [option]\n\
            \    \x1B[33;2m-\x1B[0m\x1B[32m help | h: 显示此文档\n\
            \    \x1B[33;2m-\x1B[0m\x1B[32m dir  | d: 显示日记文件目录位置\n\
            \    \x1B[33;2m-\x1B[0m\x1B[32m list | l: 显示文件列表\n\
            \    \x1B[33;2m-\x1B[0m\x1B[32m glow | g: 使用glow打开diary/目录\n\
            \    \x1B[33;2m-\x1B[0m\x1B[32m glow | m: 打开main.md\n\
            \    \x1B[33;2m-\x1B[0m\x1B[32m tudo | t: 打开~/todo.md\n\
            \    \x1B[33;2m-\x1B[0m\x1B[32m tmp  | p: 打开/tmp/tmp.md\n\x1B[0m"
          2 -> do
            putStrLn "\x1B[34mdiary/目录下的文件: \x1B[0m"
            _ <- system $ "eza diary -hl -" ++ "-reverse -s modified"
            return ()
           -- fs_ <- getDirectoryContents "diary"
           -- let fs = map (\x -> if x == todayStr ++ ".md"
           --   then "  \x1B[33;2m-\x1B[0m\x1B[32m " ++ x ++ "\x1B[0m\n" 
           --   else "  \x1B[33;2m-\x1B[32m "    ++ x ++ "\x1B[0m\n") $ filter (\x -> (x/=".") && (x/="..")) fs_
           -- putStrLn $ concat fs
          3 -> do
            _ <- system "glow ./diary"
            return ()
          4 -> do
            _ <- system $ "nvim " ++ pwd ++ "diary/main.md"
            return ()
          5 -> do 
            _ <- system $ "nvim " ++ homeD ++ "/todo.md"
            return ()
          6 -> do 
            _ <- system "nvim /tmp/tmp.md"
            return ()
          _ -> return ()
      _ -> return ()

      
  else do
    -- 未输入参数时
    -- putStrLn "\x1B[34m未输入参数, 默认打开今日文件.\x1B[0m"

    doesDiaryExist <- doesDirectoryExist "diary"
    if not doesDiaryExist then do
      _ <- system "mkdir diary"
      putStrLn "\x1B[31m未检测到diary/, 已创建文件夹\x1B[0m"
      return ()
    else putStrLn $ "\x1B[34m打开 " ++ todayStr ++ ".md ...\x1B[0m"
    _ <- rawSystem "nvim" [pwd ++ "diary/" ++ show today ++ ".md"]
    return ()
