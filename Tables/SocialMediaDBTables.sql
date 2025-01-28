USE SocialMediaDataBase;

-- Users information *login, etc
CREATE TABLE UserInformation (
	UserId INT PRIMARY KEY IDENTITY(1000000, 1),
	Username NVARCHAR(24) NOT NULL,
	EmailAddress NVARCHAR(254) NOT NULL,
	CreationDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	PasswordHash VARBINARY(255) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Country VARCHAR(56) NOT NULL
);

-- Post *Check any users post information, check specific posts with postid
CREATE TABLE Posts (
	PostId INT PRIMARY KEY IDENTITY,
	UserId INT NOT NULL,
	TextContent NVARCHAR(280),
	Likes INT DEFAULT 0,
	Comments INT DEFAULT 0,
	PostDate DATE NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (UserId) REFERENCES UserInformation(UserId)
);

-- Comments *Checking comments on post, comments made by specific user,
CREATE TABLE PostComments (
	CommentId INT PRIMARY KEY IDENTITY,
	PostId INT NOT NULL,
	UserId INT NOT NULL,
	CommentText NVARCHAR(280),
	CommentDate DATE NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	FOREIGN KEY (PostId) REFERENCES Posts(PostId)
	);

CREATE TABLE PostLikes (
	UserId INT NOT NULL,
	PostId INT NOT NULL,
	LikedDate DATE NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (Userid, Postid),
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	FOREIGN KEY (PostId) REFERENCES Posts(PostId)
	);

