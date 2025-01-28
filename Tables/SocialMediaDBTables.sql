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

