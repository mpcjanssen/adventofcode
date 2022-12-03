import * as file from 'fs';

export class FileReader {
    readData = (path: string) => {
        return new Promise<any>((resolve, reject) => {
            file.readFile(path, 'utf8', (err, data) => {
                if (err) {
                    reject(err);
                }
                resolve(data);
            })
        });
    }
}