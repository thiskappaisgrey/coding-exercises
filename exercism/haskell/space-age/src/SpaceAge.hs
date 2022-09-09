module SpaceAge (Planet(..), ageOn) where

data Planet = Mercury
            | Venus
            | Earth
            | Mars
            | Jupiter
            | Saturn
            | Uranus
            | Neptune
planetDaysRatio :: Planet -> Float
planetDaysRatio Earth = 1.0
planetDaysRatio Mercury = 0.2408467
planetDaysRatio Venus = 0.61519726
planetDaysRatio Mars =  1.8808158
planetDaysRatio Jupiter =  11.862615
planetDaysRatio Saturn =   29.447498
planetDaysRatio Uranus =  84.016846
planetDaysRatio Neptune =  164.79132
ageOn :: Planet -> Float -> Float
ageOn planet seconds = seconds / (60 * 60 * 24 * 365.25 * (planetDaysRatio planet))
