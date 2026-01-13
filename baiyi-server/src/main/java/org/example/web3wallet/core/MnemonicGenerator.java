package org.example.web3wallet.core;

import org.bitcoinj.crypto.MnemonicCode;
import org.bitcoinj.crypto.MnemonicException;
import org.bitcoinj.wallet.DeterministicSeed;

import java.security.SecureRandom;
import java.util.List;

public class MnemonicGenerator {

    public static void main(String[] args) {
        // 生成一个随机的熵（128 到 256 位，且是 32 的倍数）
        SecureRandom secureRandom = new SecureRandom();
        byte[] entropy = new byte[16]; // 128 位熵，生成 12 个助记词
        secureRandom.nextBytes(entropy);

        // 使用 BIP39 标准生成助记词
        MnemonicCode mnemonicCode = MnemonicCode.INSTANCE;
        List<String> mnemonicWords = mnemonicCode.toMnemonic(entropy);

        // 打印生成的助记词
        System.out.println("生成的助记词：");
        for (String word : mnemonicWords) {
            System.out.print(word + " ");
        }
        System.out.println();

        // 如果需要，可以从助记词生成种子
        String passphrase = ""; // 可选的密码短语
        DeterministicSeed seed = new DeterministicSeed(mnemonicWords, null, passphrase, 0);
        byte[] seedBytes = seed.getSeedBytes();

        System.out.println("生成的种子（十六进制）：");
        System.out.println(bytesToHex(seedBytes));

    }

    // 将字节数组转换为十六进制字符串
    private static String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
}
