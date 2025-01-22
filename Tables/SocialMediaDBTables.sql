USE SocialMediaDataBase;

CREATE TABLE UserInformation (
	UserId INT PRIMARY KEY,
	Username VARCHAR(24) NOT NULL,
	EmailAddress VARCHAR(254) NOT NULL,
	CreationDate SMALLDATETIME NOT NULL
);

CREATE TABLE UserPosts (
	PostId INT PRIMARY KEY IDENTITY,
	UserId INT NOT NULL,
	TextContent VARCHAR(280),
	Likes INT DEFAULT 0,
	Comments INT DEFAULT 0,
	PostDate DATE NOT NULL,
FOREIGN KEY (UserId) REFERENCES UserInformation(UserId)
);

CREATE TABLE UsersComments (
	CommentId INT PRIMARY KEY IDENTITY,
	PostId INT NOT NULL,
	UserId INT NOT NULL,
	CommentText VARCHAR(280),
	CommentDate DATE NOT NULL,
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	FOREIGN KEY (PostId) REFERENCES UserPosts(PostId)
	);

CREATE TABLE UsersLikes (
	UserId INT NOT NULL,
	PostId INT NOT NULL,
	LikedDate DATE NOT NULL,
	PRIMARY KEY (Userid, Postid),
	FOREIGN KEY (UserId) REFERENCES UserInformation(UserId),
	FOREIGN KEY (PostId) REFERENCES UserPosts(PostId)
	);