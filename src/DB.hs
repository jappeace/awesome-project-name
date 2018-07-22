{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE StandaloneDeriving    #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE DuplicateRecordFields #-}

-- | db structure and source of truth
module DB where
import qualified Data.ByteString                as BS
import qualified Data.Text                      as Text
import           Database.Beam


data UserT f = User
                { _id :: C f Int
                , _name   :: C f Text.Text
                , _email  :: C f Text.Text
                }
                  deriving Generic
type User = UserT Identity
deriving instance Show UserId
deriving instance Show User

instance Table UserT where
    data PrimaryKey UserT f = UserId (Columnar f Int) deriving Generic
    primaryKey = UserId . (_id :: UserT f -> C f Int)
type UserId = PrimaryKey UserT Identity -- For convenience

instance Beamable UserT
instance Beamable (PrimaryKey UserT)

  
data MessageT f = Message
                { _id :: C f Int
                , _from      :: PrimaryKey UserT f
                , _content   :: C f Text.Text
                }
                  deriving Generic
type Message = MessageT Identity
deriving instance Show (PrimaryKey MessageT Identity)
deriving instance Show Message

instance Table MessageT where
    data PrimaryKey MessageT f = MessageId (Columnar f Int) deriving Generic
    primaryKey = MessageId . (_id :: MessageT f -> C f Int)
type MessageId = PrimaryKey MessageT Identity -- For convenience

instance Beamable MessageT
instance Beamable (PrimaryKey MessageT)


data AwesomeDb f = AwesomeDb
                      { _ausers    :: f (TableEntity UserT)
                      , _messages :: f (TableEntity MessageT) }
                        deriving Generic

connectionString :: BS.ByteString
connectionString = "dbname=awesome_db"

instance Database be AwesomeDb

awesomeDB :: DatabaseSettings be AwesomeDb
awesomeDB = defaultDbSettings
