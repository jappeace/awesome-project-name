{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE StandaloneDeriving    #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}

-- | db structure and source of truth
module DB where
import qualified Data.ByteString                as BS
import qualified Data.Text                      as Text
import           Database.Beam
import           Database.Beam.Migrate.Generics (defaultMigratableDbSettings)
import           Database.Beam.Migrate.Types    (CheckedDatabaseSettings,
                                                 unCheckDatabase)
import           Database.Beam.Postgres         (PgCommandSyntax, Postgres)
import           Database.Beam.Postgres.Syntax  (PgColumnSchemaSyntax (..),
                                                 PgDataTypeSyntax (..))

data MessageT f = Message
                { _messageId :: C f Int
                , _from      :: PrimaryKey UserT f
                , _content   :: C f Text.Text
                }
                  deriving Generic
type Message = MessageT Identity
deriving instance Show (PrimaryKey MessageT Identity)
deriving instance Show Message

instance Table MessageT where
    data PrimaryKey MessageT f = MessageId (Columnar f Int) deriving Generic
    primaryKey = MessageId . _messageId
type MessageId = PrimaryKey MessageT Identity -- For convenience

instance Beamable MessageT
instance Beamable (PrimaryKey MessageT)

data UserT f = User
                { _userId :: C f Int
                , _name   :: C f Text.Text
                , _email  :: C f Text.Text
                }
                  deriving Generic
type User = UserT Identity
deriving instance Show (PrimaryKey UserT Identity)
deriving instance Show User

instance Table UserT where
    data PrimaryKey UserT f = UserId (Columnar f Int) deriving Generic
    primaryKey = UserId . _userId
type UserId = PrimaryKey UserT Identity -- For convenience

instance Beamable UserT
instance Beamable (PrimaryKey UserT)


data AwesomeDb f = AwesomeDb
                      { _users    :: f (TableEntity UserT)
                      , _messages :: f (TableEntity MessageT) }
                        deriving Generic

connectionString :: BS.ByteString
connectionString = "dbname=awesome_db"

instance Database be AwesomeDb


migrateDB :: CheckedDatabaseSettings Postgres AwesomeDb
migrateDB = defaultMigratableDbSettings @PgCommandSyntax

awesomeDB :: DatabaseSettings Postgres AwesomeDb
awesomeDB = unCheckDatabase migrateDB
