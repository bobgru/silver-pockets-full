module Main where

-- Use some libraries for calculating with maps and dates.
import Data.Map.Strict(Map)
import qualified Data.Map.Strict as M
import Data.Time.Calendar
import Data.Time.Calendar.OrdinalDate

-- Encode the day of your birth and your 70th birthday.
bday0  = fromGregorian 1944 11 23
bday70 = fromGregorian 2014 11 23

-- Calculate a list of all the days you lived up to age 70.
days   = [bday0..bday70]

-- Build a map (also called a dictionary) which will allow
-- us to look up the number of times a (year, month, dayOfWeek)
-- triple occurs. For example, we can look up how many times
-- (2014, 8, 5) occurs, where Friday is encoded as 5. This will
-- tell us how many Fridays there were in August 2014.

-- Define the "key" to the map--what we will use to look up the count.
-- type WeekDayCounts = Map Key Count
-- type Key           = (Year, Month, DayOfWeek)
-- type Year          = Integer
-- type Month         = Int
-- type DayOfWeek     = Int
-- type Count         = Int

-- In fact, I don't have to define the above items because
-- the Haskell compiler will deduce what they must be.

-- Convert an encoded day into a key.
mkRecord d = (y, m, dw)
    where (y, m, _) = toGregorian d
          (_, dw)   = sundayStartWeek d

-- Update the map with a new key by adding 1 to its count
-- if the key is already there, or inserting it if it's missing.
updateMap k m = M.insertWith (+) k 1 m

-- Take a list of encoded days, and "fold" them all into
-- the map, so that the map contains all the dayOfWeek counts.
initMap :: (Ord k) => [k] -> Map k Int
initMap = foldr updateMap M.empty 

-- Throw out everything except (year,month,dayOfWeek) for
-- which dayOfWeek is Sunday (0), Friday (5), or Saturday (6),
-- and the count per month is 5.
extract = M.foldrWithKey updateList []
updateList k@(_, _, dw) c kcs =
    if c == 5 && dw `elem` [0, 5, 6]
        then (k,c) : kcs
        else kcs

-- Carry out the calculations described above. The variable
-- weekDayCounts is a list of all the (year,month) pairs for
-- Fridays, Saturdays, or Sundays that occured 5 times that month.
weekDayCounts  = (map ym . extract . initMap . map mkRecord) days
ym ((y,m,_),_) = (y,m)

-- Build another map, this time counting the number of days of the
-- week for which a (year, month) pair is listed.

-- I can use the same initMap function from above, but I have to
-- define a new function to extract the list elements we want.

-- Once again, here's what is in the map, but I can leave them
-- as comments.
--
-- type Key2 = (Year, Month)
-- type MonthCounts = Map Key2 Count

-- Keep the (year,month) keys for which the count is 3, i.e. the
-- month was recorded for each of Friday, Saturday, and Sunday.
extract' = M.foldrWithKey updateList' []
updateList' k c ks
    | c == 3     =  k : ks
    | otherwise  =  ks 

-- Carry out the second phase of the calculation.
monthCounts = (extract' . initMap) weekDayCounts

-- Show the results.
main = mapM_ (putStrLn . show) monthCounts
