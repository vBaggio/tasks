CREATE TABLE tasks (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    status INT DEFAULT 0, -- 0: Pending, 1: Completed
    priority INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    completed_at DATETIME NULL
);
GO