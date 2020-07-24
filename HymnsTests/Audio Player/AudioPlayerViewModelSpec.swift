import Combine
import Mockingbird
import Nimble
import Quick
@testable import Hymns

class AudioPlayerViewModelSpec: QuickSpec {

    override func spec() {
        describe("AudioPlayerViewModel") {
            // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
            let testQueue = DispatchQueue(label: "test_queue")
            let url = URL(string: "https://www.hymnal.net/en/hymn/h/767/f=mp3")!
            var service: HymnalNetServiceMock!
            var target: AudioPlayerViewModel!
            beforeEach {
                service = mock(HymnalNetService.self)
                target = AudioPlayerViewModel(url: url, backgroundQueue: testQueue, mainQueue: testQueue, service: service)
            }
            describe("toggle repeat") {
                it("should toggle the shouldRepeat variable") {
                    expect(target.shouldRepeat).to(beFalse())
                    target.toggleRepeat()
                    expect(target.shouldRepeat).to(beTrue())
                    target.toggleRepeat()
                    expect(target.shouldRepeat).to(beFalse())
                }
            }
            context("unsuccessful music fetch") {
                beforeEach {
                    let path = Bundle(for: AudioPlayerViewModelSpec.self).path(forResource: "e0767_i", ofType: "mp3")!
                    // swiftlint:disable:next force_try
                    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
                    given(service.getData(url)) ~> { _ in
                        Just(data)
                            .tryMap({ _ -> Data in
                                throw URLError(.badServerResponse)
                            }).mapError({ _ -> ErrorType in
                                .data(description: "forced data error")
                            }).eraseToAnyPublisher()
                    }

                    target.play()
                    testQueue.sync {}
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("should set playback state to stopped") {
                    verify(service.getData(url)).wasCalled(1)
                    expect(target.playbackState).to(equal(.stopped))
                }
            }
            context("successful music fetch") {
                beforeEach {
                    let path = Bundle(for: AudioPlayerViewModelSpec.self).path(forResource: "e0767_i", ofType: "mp3")!
                    // swiftlint:disable:next force_try
                    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
                    given(service.getData(url)) ~> { _ in
                        Just(data).mapError({ _ -> ErrorType in
                            .data(description: "This will never get called")
                        }).eraseToAnyPublisher()
                    }

                    target.play()
                    testQueue.sync {}
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("should set playback state to playing") {
                    verify(service.getData(url)).wasCalled(1)
                    expect(target.playbackState).to(equal(.playing))
                }
                describe("pause") {
                    beforeEach {
                        target.pause()
                    }
                    it("should set playback state to stopped") {
                        expect(target.playbackState).to(equal(.stopped))
                    }
                    describe("play again") {
                        beforeEach {
                            reset(service)
                            target.play()
                        }
                        it("should set playback state to playing without calling the service") {
                            expect(target.playbackState).to(equal(.playing))
                        }
                    }
                }
                describe("reset") {
                    beforeEach {
                        target.reset()
                    }
                    it("should set playback state to stopped") {
                        expect(target.playbackState).to(equal(.stopped))
                    }
                    describe("play again") {
                        beforeEach {
                            clearInvocations(on: service)
                            target.play()
                            testQueue.sync {}
                            testQueue.sync {}
                            testQueue.sync {}
                        }
                        it("should call the service again and set the playback to playing") {
                            verify(service.getData(url)).wasCalled(1)
                            expect(target.playbackState).to(equal(.playing))
                        }
                    }
                }
            }
        }
    }
}
