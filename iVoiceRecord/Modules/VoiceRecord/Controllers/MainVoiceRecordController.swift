//
//  MainVoiceRecognitionController.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxDataSources

protocol MainVoiceRecordOutput: class {

    func showDetails(forTrack viewModel: VoiceTrackViewModel)
}

protocol MainVoiceRecordInput: class {
    func setViewModel(_ viewModel: VoiceRecordViewModel)
}


class MainVoiceRecordController: UIViewController, MainVoiceRecordInput {
    
    var output      : MainVoiceRecordOutput?

    
    //MARK: Views
    var mainVoiceRecordView : MainVoiceRecordStatusView?
    var bottomRecordinView  : VoiceRecordView?
    var tableView           : UITableView = UITableView()
    
    var recordingPlaceholderView    : UIView = UIView()
    var emptyTableLabel             : UILabel = UILabel()
    
    //MARK: Models
    var viewModel   : VoiceRecordViewModel?
    
    //MARK: Others
    var disposeBag = DisposeBag()
    
    
    //MARK: Implementations
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        prepareViews()
        
        prepareLayout()
    }
    
    //MARK: Preparing
    private func prepareNavigationBar() {
        title = "iVoiceRocord"
        
        navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    private func prepareViews() {
        
        //tableView
        prepareTableView()
        prepaerBottomView()
        prepareMainVoiceRecordingView()
        
        //emptyTableLabel
        emptyTableLabel.text = "No voice tracks. Tap 'Record' for start. "
        emptyTableLabel.textColor = .black
        emptyTableLabel.font = UIFont.boldSystemFont(ofSize: 34)
        emptyTableLabel.numberOfLines = 0
        view.addSubview(emptyTableLabel)
    }
    
    private func prepareMainVoiceRecordingView() {
        guard let viewModel = viewModel else { return }
        
        //bottomRecordinView
        let mainVoiceRecordView = MainVoiceRecordStatusView(progressVariable: viewModel.audionService.recordingProgressVariable,
                                                 statusVariable: viewModel.audionService.recordingStatus)
        mainVoiceRecordView.alpha = 0.0
        mainVoiceRecordView.recordActionClosure = { [weak self] in
            self?.viewModel?.record()
        }
        
        viewModel.audionService.recordingStatus.asObservable().observeOn(MainScheduler.instance)
            .bind { (status) in
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.mainVoiceRecordView?.alpha = (status == .stoped) ? 0.0 : 1.0
                })

        }.disposed(by: disposeBag)
        view.addSubview(mainVoiceRecordView)
        
        self.mainVoiceRecordView = mainVoiceRecordView
    }
    
    private func prepaerBottomView() {
        guard let viewModel = viewModel else { return }

        //bottomRecordinView
        let bottomRecordinView = VoiceRecordView(progressVariable: viewModel.audionService.recordingProgressVariable,
                                                 statusVariable: viewModel.audionService.recordingStatus)
        bottomRecordinView.recordActionClosure = { [weak self] in
            guard let `self` = self else { return }
          
            self.canRecordVoiceByMicro(disposeBag: self.disposeBag, completion: { (isSuccess) in
                if isSuccess {
                    self.viewModel?.record()
                }
            })
        }
        
        view.addSubview(bottomRecordinView)
        
        self.bottomRecordinView = bottomRecordinView
    }
    
    private func prepareTableView() {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        
        tableView.estimatedRowHeight = VoiceTrackTVC.standardHeight
        tableView.tableHeaderView = emptyView
        tableView.tableFooterView = emptyView
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = UIColor(red: 250.0/255.0, green: 251.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        tableView.separatorInset = UIEdgeInsets.zero
        
        tableView.register(VoiceTrackTVC.self, forCellReuseIdentifier: VoiceTrackTVC.identifier)
        view.addSubview(tableView)

        /* Bind. */
        bindTableView()
    }
    
    private func  bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModels>(configureCell: { [weak self] (ds, tv, ip, _) -> UITableViewCell in
            guard let `self` = self else { return UITableViewCell() }
            
            if let model = ds[ip] as? VoiceTrackViewModel {
                if let cell = tv.dequeueReusableCell(withIdentifier: VoiceTrackTVC.identifier, for: ip) as? VoiceTrackTVC {
                    
                    /* cell filling */
                    cell.fill(withViewModel: model)
                  
                    /* Handle actions. */
                    cell.mainActionClosure = { [weak self] (viewModel) in
                        self?.viewModel?.playFile(forViewModel: viewModel)
                    }
                    cell.removeActionClosure = { [weak self] (viewModel) in
                        self?.viewModel?.removeFile(forViewModel: viewModel)
                    }
                    return cell
                }
            }
            return UITableViewCell()
        })
        
        
        let modelsObserver = viewModel?.sections.asObservable().observeOn(MainScheduler.instance).do(onNext: { [weak self] (section) in
            guard let `self` = self else { return }
          
            if section.first ==  nil {
                self.emptyTableLabel.isHidden = false
            } else {
                self.emptyTableLabel.isHidden = true
            }
        })
        
        modelsObserver?.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
           
            self.tableView.deselectRow(at: indexPath, animated: true)

            
            if let trackVM = self.viewModel?.sections.value[indexPath.section].items[indexPath.row] as? VoiceTrackViewModel {
                guard  self.viewModel?.isServiceActiveNow == false else {
                   
                    let alert = UIAlertController(title: "Warning.", message: "Complete working with service before going to details. You need stopped processes playing and recording.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
                self.output?.showDetails(forTrack: trackVM)
            }
        }).disposed(by: disposeBag)
    }
    
    private func prepareLayout() {
        
        //mainVoiceRecordView
        mainVoiceRecordView?.snp.makeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.left.top.right.bottom.equalTo(self.tableView)
        })
        
        //bottomRecordinView
        bottomRecordinView?.snp.makeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(VoiceRecordView.standardHeight)
        })
        
        //tableView
        tableView.snp.makeConstraints { [weak self] (make) in
            guard let `self` = self else { return }
            guard let bottomRecordinView = self.bottomRecordinView else { return }
            
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomRecordinView.snp.top)
        }
        
        emptyTableLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.tableView)
            make.bottom.equalTo(self.tableView).offset(-20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    //MARK: Input
    func setViewModel(_ viewModel: VoiceRecordViewModel) {
        self.viewModel = viewModel
    }
}


// MARK: UITableViewDelegate
extension MainVoiceRecordController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VoiceTrackTVC.standardHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return VoiceTracksSectionHeader.standardHeight
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerModel = self.viewModel?.sections.value[section].headerVM
            as? SimpleVoiceTracksSectionHeaderViewModel {
            
            let header = VoiceTracksSectionHeader()
            header.title = headerModel.title.uppercased()
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
