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
}
