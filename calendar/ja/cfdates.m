% CFDATES �m�藘�t�̃L���b�V���t���[���t
%
% ���̊֐��́ANUMBONDS �̊m�藘�t���ɂ��āA�L���b�V���t���[�x������
% ���t�s����o�͂��܂��B���̊֐��́A�ŏ��́A�܂��͍Ō�̃N�[�|���x��
% �܂ł̊��Ԃ̒��Z�ւ�炸���̑S�ẴL���b�V���t���[���t���o�͂��܂��B
%
%   CFlowDates = cfdates(Settle, Maturity)
%
%   CFlowDates = cfdates(Settle, Maturity, Period, Basis, 
%                        EndMonthRule, IssueDate, FirstCouponDate, 
%                        LastCouponDate)
% ����: 
%     Settle - ���ϓ�
%     Maturity - ������
%
% �I�v�V�����̓���:
%     Period - �N������̃N�[�|���x����; �f�t�H���g�� 2 (���N����).
%     Basis - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%     EndMonthRule - �����K��; �f�t�H���g�� 1 (�����K���͗L��)
%     IssueDate - ���̔��s��
%     FirstCouponDate - �ŏ��̃N�[�|���x����
%     LastCouponDate - �ŏI�N�[�|���x���� 
%
% �o��:
%     �V���A�����t�`���ŕ\�����ꂽ���ۂ̃L���b�V���t���[�x����������Ȃ�s��ł��B
%     CFlowDates �s��̍s�̐��� NUMBONDS �ŁA��̐��͍��|�[�g�t�H���I��ۗL����
%     ���Ƃɂ��v�������L���b�V���t���[�x���������̍ő�l�ɂ���Č��肳��܂��B
%     �L���b�V���t���[�x�����̐����ACFlowDates �s��̍s���ɂ���Ď������ő�l���
%     ���Ȃ����ɂ��ẮANaN �l�ɂ���Č��������s���܂��B
%
% ����:
%     �K�{�̈����͑S�āANUMBONDS�s1��A�܂��� 1�sNUMBONDS�� �̃x�N�g���A�܂���
%     �X�J�������łȂ���΂Ȃ�܂���B�I�v�V�����ƂȂ�S�Ă̈����́ANUMBONDS�s1��A
%     �܂���1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��͋�s��łȂ���΂Ȃ�܂���B
%     �l�̎w��̂Ȃ����͂ɂ� NaN ����̓x�N�g���Ƃ��Đݒ肵�Ă��������B���t�́A
%     �V���A�����t�ԍ��A�܂��͓��t������ł��B
%
%     ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%     'help ftb' + ������ (���Ƃ��΁ASettle (���ϓ�) �Ɋւ���w���v�́A
%     "help ftbSettle") �ƃ^�C�v���ē����܂��B
%
% �Q�l CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%      CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.

% Copyright 1995-2006 The MathWorks, Inc.
