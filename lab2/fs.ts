type Dir = {
    name: string;
    children?: Dir[];
};

const fs: Dir = {
    name: "folder",
    children: [
        { name: "file1.txt" },
        { name: "file2.txt" },
        {
            name: "images",
            children: [
                { name: "image.png" },
                {
                    name: "vacation",
                    children: [
                        { name: "crocodile.png" },
                        { name: "penguin.png" },
                    ],
                },
            ],
        },
        { name: "shopping-list.pdf" },
    ],
};

function printDir(dir: Dir, level: number) {
    if (!dir.children) {
        return console.log(dir.name.padStart(dir.name.length + level, "\t"));
    }

    return dir.children.forEach((dir) => {
        printDir(dir, level + 1);
    });
}

printDir(fs, 0);

function printDirNoRec(dir: Dir) {
    let stack: { dir: Dir; level: number }[] = [{ dir, level: 0 }];

    while (!!stack.length) {
        const { dir, level } = stack.pop()!;

        console.log(dir.name.padStart(dir.name.length + level, "\t"));
        if (dir.children) {
            stack = stack.concat(
                dir.children.map((dir) => ({ dir, level: level + 1 }))
            );
        }
    }
}

console.log("\n=========\n");

printDirNoRec(fs);

const a = Promise.resolve(1);
a.then(console.log);

const b = Promise.reject(2);
b.catch(() => console.log(`catch b`));

const c = Promise.reject(3);
c.finally(() => console.log(`finally c`));
c.catch(() => console.log(`catch c`));
