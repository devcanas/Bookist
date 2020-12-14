import UIKit

class RoomChoiceStep: BookingStepView {
    override var step: BookingStep { .roomChoice }
    override var canMoveForward: Bool { roomsCollectionView.indexPathsForSelectedItems?.count == 1 }
    
    private var stepHeightAnchor: NSLayoutConstraint?
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let title: Padded<Title> = createPadded {
        $0.render(with: .withImage(Constants.Text.availableRooms, Constants.Image.rooms))
    }
    
    private let filtersButtonStack: UIStackView = create {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 10
    }
    
    private let filtersButton: Button = create {
        $0.render(with: [
            .text(Constants.Text.filters),
            .image(Constants.Image.filters),
            .vertical(false),
            .bordered(true),
            .noBackground
        ])
    }
    
    private let filtersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let roomsPaddedWrapper: Padded<UIStackView> = createPadded { _ in }
    private let roomsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var filterDataSource = makeFiltersDataSource()
    private lazy var roomDataSource = makeRoomDataSource()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func render(with configuration: BookingStepView.Configuration) {
        super.render(with: configuration)
        filtersCollectionView.delegate = self
        roomsCollectionView.delegate = self
        
        configureViews()
        
        guard stepHeightAnchor == nil, let superView = superview?.superview else { return }
        if superView.frame.height > 0 {
            stepHeightAnchor = heightAnchor.constraint(equalToConstant: superView.frame.height)
            stepHeightAnchor?.isActive = true
        }
    }
    
    private func configureViews() {
        applyFiltersSnapshot()
        applyRoomsSnapshot()
    }
    
    private func setup() {
        setupSubviews()
        setupFiltersCollectionView()
        setupRoomsCollectionView()
    }
    
    func setupSubviews() {
        addArrangedSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(filtersButtonStack)
        filtersButtonStack.addArrangedSubview(filtersButton)
        filtersButtonStack.addArrangedSubview(filtersCollectionView)
        stackView.addArrangedSubview(roomsPaddedWrapper)
        roomsPaddedWrapper.view.addArrangedSubview(roomsCollectionView)
    }
    
    private func setupFiltersCollectionView() {
        filtersCollectionView.backgroundColor = Constants.Color.theme
        filtersCollectionView.showsHorizontalScrollIndicator = false
        filtersCollectionView.allowsMultipleSelection = true
        filtersCollectionView.register(FiltersCell.self, forCellWithReuseIdentifier: FiltersCell.identifier)
        filtersCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if let layout = filtersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func setupRoomsCollectionView() {
        roomsCollectionView.backgroundColor = Constants.Color.theme
        roomsCollectionView.showsVerticalScrollIndicator = false
        roomsCollectionView.allowsMultipleSelection = false
        roomsCollectionView.register(RoomCell.self, forCellWithReuseIdentifier: RoomCell.identifier)
        
        if let layout = roomsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 20
        }
    }
    
    private func makeFiltersDataSource() -> FilterDataSource {
        return FilterDataSource(
            collectionView: filtersCollectionView,
            cellProvider: { (collectionView, indexPath, filter) -> FiltersCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCell.identifier, for: indexPath) as? FiltersCell
                cell?.render(with: .text(filter.rawValue))
                return cell
            })
    }
    
    private func applyFiltersSnapshot(animated: Bool = true) {
        var snapshot = FilterSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(model.filters)
        filterDataSource.apply(snapshot)
    }
    
    private func makeRoomDataSource() -> RoomDataSource {
        return RoomDataSource(
            collectionView: roomsCollectionView,
            cellProvider: { (collectionView, indexPath, room) -> RoomCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCell.identifier, for: indexPath) as? RoomCell
                cell?.render(with: .room(room))
                return cell
            })
    }
    
    private func applyRoomsSnapshot(animated: Bool = true) {
        var snapshot = RoomSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(journey.metadata.rooms)
        roomDataSource.apply(snapshot)
    }
}

extension RoomChoiceStep: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == roomsCollectionView {
            let cellWidth = collectionView.frame.width / 2 - 30
            return CGSize(width: cellWidth, height: cellWidth / 1.5)
        } else {
            let filterStr = filterDataSource.itemIdentifier(for: indexPath)?.rawValue
            return CGSize(width: (filterStr ?? "").size(withAttributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ]).width + 20, height: collectionView.frame.height - 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        collectionView == roomsCollectionView
            ? UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
    }
    
    // filter rooms with newly updated filters
    // save room
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView {
            guard let selectedFilter = filterDataSource.itemIdentifier(for: indexPath) else { return }
            model.appliedFilters.append(selectedFilter)
            let temp = model.filters.remove(at: indexPath.row)
            model.filters.insert(temp, at: .zero)
        } else {
            model.room = roomDataSource.itemIdentifier(for: indexPath)
        }
        delegate?.didUpdateStep(with: model, in: step)
    }
    
    // filter rooms with newly updated filters
    // set room to nil
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView {
            guard let deSelectedFilter = filterDataSource.itemIdentifier(for: indexPath) else { return }
            let temp = model.filters.remove(at: indexPath.row)
            model.filters.append(temp)
            model.appliedFilters = model.appliedFilters.filter { $0 != deSelectedFilter }
        } else {
            model.room = nil
        }
        delegate?.didUpdateStep(with: model, in: step)
    }
}
