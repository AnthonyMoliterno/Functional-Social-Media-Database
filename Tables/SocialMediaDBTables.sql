USE SocialMediaDataBase;

-- Users information *login, etc
CREATE TABLE UserInformation (
	UserId INT PRIMARY KEY IDENTITY(1000000, 1),
	Username NVARCHAR(24) NOT NULL,
	EmailAddress NVARCHAR(254) NOT NULL,
	CreationDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	PasswordHash VARBINARY(255) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Country VARCHAR(56) NOT NULL,
	Bio NVARCHAR(160) NULL,
	ProfilePictureUrl VARCHAR(255) NULL,
	FollowerCount INT DEFAULT 0,
	FollowingCount INT DEFAULT 0,
	CONSTRAINT UQ_UserEmail UNIQUE (EmailAddress)
);

-- Post *Check any users post information, check specific posts with postid
CREATE TABLE Post (
	PostId INT PRIMARY KEY IDENTITY(1, 1),
	UserId INT NOT NULL,
	TextContent NVARCHAR(280) NULL,
	Likes INT DEFAULT 0,
	Comments INT DEFAULT 0,
	MediaUrl VARCHAR(255) NULL,
	PostDate DATE NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId) ON DELETE CASCADE,

	-- Ensure a comment has a TextContent or MediaUrl
	CONSTRAINT CHK_Post_Valid CHECK (TextContent IS NOT NULL OR MediaURL IS NOT NULL)
);

CREATE TABLE PostMedia (
    MediaId INT PRIMARY KEY IDENTITY,
    PostId INT NOT NULL,
    UserId INT NOT NULL,
    MediaUrl VARCHAR(255) NOT NULL,
    MediaType VARCHAR(50) NOT NULL,
    MediaDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (PostId) REFERENCES Post(PostId) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	
	--Ensure media types are valid
    CONSTRAINT CHK_MediaType CHECK (MediaType IN ('image', 'video', 'audio'))
);

-- Comments *Checking comments on post, comments made by specific user,
CREATE TABLE PostComments (
	CommentId INT PRIMARY KEY IDENTITY,
	PostId INT NOT NULL,
	UserId INT NOT NULL,
	CommentText NVARCHAR(280) NULL,
	CommentDate DATE NOT NULL DEFAULT GETDATE(),
	MediaUrl VARCHAR(255) NULL,
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	FOREIGN KEY (PostId) REFERENCES Posts(PostId) ON DELETE CASCADE,

	-- Ensure a comment has either a CommentText or MediaUrl
	CONSTRAINT CHK_Post_Valid CHECK (CommentText IS NOT NULL OR MediaURL IS NOT NULL)
);

-- Comments made with multiple images or videos attached 
CREATE TABLE CommentMedia (
	MediaId INT PRIMARY KEY IDENTITY,
	CommentId INT NOT NULL,
	UserId INT NOT NULL,
	MediaUrl VARCHAR(255) NOT NULL,
	MediaType VARCHAR(50) NULL,
	FOREIGN KEY (CommentId) REFERENCES PostComments(CommentId) ON DELETE CASCADE,
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	-- Ensure media types are valid
	CONSTRAINT CHK_MediaType CHECK (MediaType IN ('image', 'video', 'audio'))

	);

-- A post likes *trace who liked a post, etc
CREATE TABLE PostLikes (
	UserId INT NOT NULL,
	PostId INT NOT NULL,
	LikedDate DATE NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (Userid, Postid),
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	FOREIGN KEY (PostId) REFERENCES Posts(PostId)
	);

CREATE TABLE Followers (
	FollowerId INT NOT NULL,
	FollowedId INT NOT NULL,
	FollowDate DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (FollowerId, FollowedId),
	FOREIGN KEY (FollowerId) REFERENCES UserInformation(UserId) ON DELETE CASCADE,
	FOREIGN KEY (FollowedId) REFERENCES UserInformation(UserId) ON DELETE CASCADE,
	CONSTRAINT CHK_NoSelfFollow CHECK (FollowerId != FollowerId)
	);

CREATE TABLE Following (
    UserId INT NOT NULL,
    FollowerId INT NOT NULL,
    FollowDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (UserId, FollowerId),
    FOREIGN KEY (UserId) REFERENCES UserInformation(UserId) ON DELETE CASCADE,
    FOREIGN KEY (FollowerId) REFERENCES UserInformation(UserId) ON DELETE CASCADE,
    CONSTRAINT CHK_NoSelfFollow CHECK (FollowerId != UserId)
);



-- Index for Post table to improve searching and filtering by user
CREATE INDEX IDX_Post_UserId ON Post(UserId);

-- Index for PostLikes table to optimize queries based on who liked a post
CREATE INDEX IDX_PostLikes_PostId ON PostLikes(PostId);

-- Index for PostLikes table to optimize queries based on who liked a specific user’s post
CREATE INDEX IDX_PostLikes_UserId ON PostLikes(UserId);

-- Index for PostComments table to speed up queries on comments by PostId or UserId
CREATE INDEX IDX_PostComments_PostId ON PostComments(PostId);
CREATE INDEX IDX_PostComments_UserId ON PostComments(UserId);

-- Index for Followers table to optimize queries on who follows whom
CREATE INDEX IDX_FollowedId ON Followers(FollowedId);

-- Index for Following table to optimize queries on who is following whom
CREATE INDEX IDX_FollowerId ON Following(FollowerId);
CREATE INDEX IDX_UserId ON Following(UserId);



	
