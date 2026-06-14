//
//  SettingsView.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var hfToken = ""
    @State private var modelsPath = "~/Library/Application Support/Mox/models"
    @State private var defaultTemperature = 0.7
    @State private var serverPort = 8000

    var body: some View {
        Form {
            Section("Hugging Face") {
                SecureField("액세스 토큰 (게이트 모델용)", text: $hfToken)
                Text("토큰은 Keychain에 안전하게 저장됩니다.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("저장소") {
                LabeledContent("모델 경로", value: modelsPath)
            }

            Section("기본 생성 파라미터") {
                LabeledContent("Temperature") {
                    Slider(value: $defaultTemperature, in: 0...2, step: 0.1)
                        .frame(width: 180)
                }
            }

            Section("로컬 서버") {
                Stepper("포트: \(serverPort)", value: $serverPort, in: 1024...65535)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("설정")
    }
}
