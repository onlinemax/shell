pragma Singleton

import Quickshell

Singleton {

    function importAsset(asset: string): string {
        return `file://${Quickshell.shellDir}/assets/${asset}`;
    }
    function importGeneratedAsset(asset: string): string {
        return `file://${Quickshell.shellDir}/assets/generated/${asset}`;
    }
    function elispsalize(text: string, maxLength: int): string {
        if (text.length <= maxLength) {
            return text;
        }
        return text.substring(0, maxLength - 3) + "...";
    }

    function encodeBase64(array): string {
        const TWO_PW = [1, 3, 7, 15, 31, 63, 127, 255];

        function get6BitByteAt(array, index) {
            const bitIndex = index * 6;

            if (bitIndex >= array.length * 8) {
                return -1;
            }

            const byteIndex = bitIndex >> 3;
            const offset = bitIndex & 7;
            if (offset > 2) {
                const start = array[byteIndex] & TWO_PW[8 - offset - 1];
                const end = array[byteIndex + 1] >> (8 - ((offset + 6) & 7));
                return (start << (-2 + offset)) | (byteIndex != array.length - 1 ? end : 0);
            }
            const start = array[byteIndex] & TWO_PW[8 - offset - 1];
            return start >> (2 - offset);
        }
        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        const len = Math.ceil(array.length * 8 / 6);
        const padding = ((array.length * 8) % 6) >> 1;

        const stringBuilder = new Array(len + padding);

        for (let i = 0; i < len; i++) {
            stringBuilder[i] = chars[get6BitByteAt(array, i)];
        }
        for (let i = 0; i < padding; i++) {
            stringBuilder[len + i] = "=";
        }

        return stringBuilder.join("");
    }
    function fetchImage(url, contentType, callback): string {
        const xhr = new XMLHttpRequest();

        xhr.responseType = 'arraybuffer';

        xhr.onreadystatechange = function () {
            if (xhr.readyState != XMLHttpRequest.DONE) {
                return;
            }
            const base64String = `data:${contentType};base64,` + Utils.encodeBase64(new Uint8Array(xhr.response));
            callback(base64String);
        };

        xhr.open("GET", url);
        xhr.send();
    }
    function filterDesktopEntries(entries, term) {
        function includes(s) {
            return s.toLowerCase().includes(term.toLowerCase().trim());
        }
        return entries.filter(entry => includes(entry.name) || includes(entry.genericName) || entry.keywords.some(keyword => includes(keyword)) || entry.categories.some(keyword => includes(keyword)));
    }
}
