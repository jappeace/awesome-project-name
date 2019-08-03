{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE StandaloneDeriving    #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}

-- | db structure and source of truth
module Awe.Back.DB where
import qualified Data.Text                       as Text
import           Database.Beam
import           Database.Beam.Backend.SQL.Types (SqlSerial)
import           Database.Beam.Migrate
import           Database.Beam.Postgres          (Postgres)


data UserT f = User
                { _user_id :: C f (SqlSerial Int)
                , _name    :: C f Text.Text
                , _email   :: C f Text.Text
                }
                  deriving Generic
type User = UserT Identity
deriving instance Show UserId
deriving instance Show User

instance Table UserT where
    data PrimaryKey UserT f = UserId (Columnar f (SqlSerial Int)) deriving Generic
    primaryKey = UserId . _user_id
type UserId = PrimaryKey UserT Identity -- For convenience

instance Beamable UserT
instance Beamable (PrimaryKey UserT)


data MessageT f = Message
                { _message_id :: C f (SqlSerial Int)
                , _from       :: PrimaryKey UserT f
                , _content    :: C f Text.Text
                }
                  deriving Generic
type Message = MessageT Identity
deriving instance Show (PrimaryKey MessageT Identity)
deriving instance Show Message

instance Table MessageT where
    data PrimaryKey MessageT f = MessageId (Columnar f (SqlSerial Int)) deriving Generic
    primaryKey = MessageId . _message_id
type MessageId = PrimaryKey MessageT Identity -- For convenience

instance Beamable MessageT
instance Beamable (PrimaryKey MessageT)


data AwesomeDb f = AwesomeDb
                      { _ausers   :: f (TableEntity UserT)
                      , _messages :: f (TableEntity MessageT) }
                        deriving Generic

instance Database Postgres AwesomeDb

awesomeDB :: DatabaseSettings Postgres AwesomeDb
awesomeDB = unCheckDatabase checkedAwesomeDB

checkedAwesomeDB :: CheckedDatabaseSettings Postgres AwesomeDb
checkedAwesomeDB = defaultMigratableDbSettings @Postgres
