import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/controllers/rtm_controller_helper.dart';
import 'package:agora_uikit/controllers/rtm_token_handler.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_rtm_client_event_handler.dart';
import 'package:agora_uikit/models/rtm_message.dart';
import 'package:agora_uikit/src/enums.dart';

Future<void> rtmClientEventHandler({
  required AgoraRtmClient agoraRtmClient,
  required AgoraRtmCallManager agoraRtmCallManager,
  required AgoraRtmClientEventHandler agoraRtmClientEventHandler,
  required SessionController sessionController,
}) async {
  const String tag = "AgoraVideoUIKit";

  agoraRtmClient.onMessageReceived = (RtmMessage message, String peerId) {
    agoraRtmClientEventHandler.onMessageReceived?.call(message, peerId);
    Message msg = Message(text: message.text);
    String? messageType;

    message.toJson().forEach((key, val) {
      if (key == "text") {
        var json = jsonDecode(val.toString());
        messageType = json['messageType'];
      }
    });
    messageReceived(
      messageType: messageType!,
      message: msg.toJson(),
      sessionController: sessionController,
    );
  };

  agoraRtmClient.onConnectionStateChanged = (int state, int reason) {
    agoraRtmClientEventHandler.onConnectionStateChanged?.call(state, reason);

    log(
      'Connection state changed : ${state.toString()}, reason : ${reason.toString()}',
      level: Level.info.value,
      name: tag,
    );
    if (state == 5) {
      agoraRtmClient.logout();
    }
  };

  agoraRtmClient.onError = (error) {
    agoraRtmClientEventHandler.onError?.call(error);

    log(
      'Error Occurred while initializing the RTM client: ${error.hashCode}',
      level: Level.error.value,
      name: tag,
    );
  };

  agoraRtmClient.onTokenExpired = () {
    agoraRtmClientEventHandler.onTokenExpired?.call();

    getRtmToken(
      tokenUrl: sessionController.value.connectionData!.tokenUrl,
      sessionController: sessionController,
    );
  };

  agoraRtmCallManager.onLocalInvitationReceivedByPeer =
      (LocalInvitation invitation) {
    agoraRtmClientEventHandler.onLocalInvitationReceivedByPeer
        ?.call(invitation);
  };

  agoraRtmCallManager.onLocalInvitationAccepted =
      (LocalInvitation invitation, String tempString) {
    agoraRtmClientEventHandler.onLocalInvitationAccepted?.call(invitation);
  };

  agoraRtmCallManager.onLocalInvitationRefused =
      (LocalInvitation invitation, String tempString) {
    agoraRtmClientEventHandler.onLocalInvitationRefused?.call(invitation);
  };

  agoraRtmCallManager.onLocalInvitationCanceled =
      (LocalInvitation invitation) {
    agoraRtmClientEventHandler.onLocalInvitationCanceled?.call(invitation);
  };

  agoraRtmCallManager.onLocalInvitationFailure =
      (LocalInvitation invitation, int errorCode) {
    agoraRtmClientEventHandler.onLocalInvitationFailure
        ?.call(invitation, errorCode);
  };

  agoraRtmCallManager.onRemoteInvitationReceived =
      (RemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationReceivedByPeer
        ?.call(invitation);
  };

  agoraRtmCallManager.onRemoteInvitationAccepted =
      (RemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationAccepted?.call(invitation);
  };

  agoraRtmCallManager.onRemoteInvitationRefused =
      (RemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationRefused?.call(invitation);
  };

  agoraRtmCallManager.onRemoteInvitationCanceled =
      (RemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationCanceled?.call(invitation);
  };

  agoraRtmCallManager.onRemoteInvitationFailure =
      (RemoteInvitation invitation, int errorCode) {
    agoraRtmClientEventHandler.onRemoteInvitationFailure
        ?.call(invitation, errorCode);
  };
}
